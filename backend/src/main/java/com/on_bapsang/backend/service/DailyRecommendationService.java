package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.RecipeSummaryDto;
import com.on_bapsang.backend.entity.DailyIndex;
import com.on_bapsang.backend.entity.Recipe;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.entity.UserDailyRecipe;
import com.on_bapsang.backend.repository.*;
import org.springframework.transaction.annotation.Transactional;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class DailyRecommendationService {

    private static final long DEFAULT_START_ID = 7016813L;
    private static final long MAX_ID_EXCLUSIVE = 7038813L; // 예시 상한 (포함 X)
    private static final int WINDOW_SIZE = 100;
    private static final int PICK_SIZE = 6;

    private final RecipeRepository recipeRepository;
    private final RecipeIngredientRepository recipeIngredientRepository;
    private final UserFavoriteDishRepository userFavoriteDishRepository;
    private final UserFavoriteIngredientRepository userFavoriteIngredientRepository;
    private final DailyIndexRepository dailyIndexRepository;
    private final UserDailyRecipeRepository userDailyRecipeRepository;
    private final RecipeScrapRepository recipeScrapRepository;

    /**
     * 로그인 사용자의 일일 추천.
     * - null 사용자면 게스트 로직으로 우회
     * - 사용자별로 당일 한 번 계산/저장 후 재사용
     */
    @Transactional
    public List<Recipe> getDailyRecommendedRecipes(User user) {
        if (user == null) {
            return getDailyRecommendedRecipesForGuest();
        }

        LocalDate today = LocalDate.now();

        // 1) 이미 저장된 추천이 있으면 반환
        List<UserDailyRecipe> savedList = userDailyRecipeRepository.findByUserAndDate(user, today);
        if (!savedList.isEmpty()) {
            List<String> recipeIds = savedList.get(0).getRecipeIds();
            return recipeRepository.findAllById(recipeIds);
        }

        // 2) 오늘의 시작 ID 범위 계산
        DailyIndex index = dailyIndexRepository.findById(1L).orElseGet(DailyIndex::new);
        long startId = (index.getStartRecipeId() == null) ? DEFAULT_START_ID : index.getStartRecipeId();
        long endId = startId + WINDOW_SIZE;

        // 3) 사용자 선호 정보 수집
        List<Long> favoriteIngredientIds = userFavoriteIngredientRepository.findIngredientIdsByUser(user);
        List<String> favoriteDishNames = userFavoriteDishRepository.findDishNamesByUser(user);

        // 4) 후보 레시피 로드
        List<Recipe> candidates = recipeRepository.findByRecipeIdBetween(startId, endId);

        // 5) 점수화
        List<RecipeScore> scored = new ArrayList<>(candidates.size());
        for (Recipe recipe : candidates) {
            int score = 0;

            // 이름 기반 가중치
            for (String dishName : favoriteDishNames) {
                if (recipe.getName().equalsIgnoreCase(dishName)) {
                    score += 3;
                } else if (recipe.getName().contains(dishName)) {
                    score += 1;
                }
            }

            // 재료 유사도 기반 가중치
            List<Long> recipeIngreIds = recipeIngredientRepository.findIngredientIdsByRecipe(recipe.getRecipeId());
            if (!recipeIngreIds.isEmpty() && !favoriteIngredientIds.isEmpty()) {
                long matchCount = recipeIngreIds.stream().filter(favoriteIngredientIds::contains).count();
                double similarity = (double) matchCount / recipeIngreIds.size(); // 0~1
                score += (int) (similarity * 10); // 0~10
            }

            scored.add(new RecipeScore(recipe, score));
        }

        // 6) 점수 높은 순으로 우선 픽
        List<Recipe> top = scored.stream()
                .filter(rs -> rs.score > 0)
                .sorted((a, b) -> Integer.compare(b.score, a.score))
                .limit(PICK_SIZE)
                .map(rs -> rs.recipe)
                .collect(Collectors.toList());

        // 7) 부족하면 후보군에서 채움 → 그래도 부족하면 전체 DB에서 채움
        fillUpTo(top, candidates, PICK_SIZE);
        if (top.size() < PICK_SIZE) {
            fillFromAll(top, PICK_SIZE);
        }

        // 8) 저장 (사용자별/당일)
        UserDailyRecipe entry = new UserDailyRecipe();
        entry.setUser(user);
        entry.setDate(today);
        entry.setRecipeIds(top.stream().map(Recipe::getRecipeId).collect(Collectors.toList()));
        userDailyRecipeRepository.save(entry);

        return top;
    }

    /**
     * 게스트(비로그인) 추천:
     * - DailyIndex 윈도우(100개)에서 날짜 기반 시드로 셔플 → 상위 6개
     * - 후보 없으면 전체에서 날짜 시드로 셔플 → 6개
     * - DB 저장 없음
     */
    @Transactional(readOnly = true)
    public List<Recipe> getDailyRecommendedRecipesForGuest() {
        LocalDate today = LocalDate.now();

        DailyIndex index = dailyIndexRepository.findById(1L).orElseGet(DailyIndex::new);
        long startId = (index.getStartRecipeId() == null) ? DEFAULT_START_ID : index.getStartRecipeId();
        long endId = startId + WINDOW_SIZE;

        List<Recipe> candidates = recipeRepository.findByRecipeIdBetween(startId, endId);

        // 같은 날에는 같은 결과가 나오도록 날짜(epochDay)로 시드 고정
        Random seeded = new Random(today.toEpochDay());

        if (!candidates.isEmpty()) {
            Collections.shuffle(candidates, seeded);
            return candidates.stream().limit(PICK_SIZE).collect(Collectors.toList());
        }

        // 안전망: 전체에서 날짜 시드 셔플 후 6개
        List<Recipe> all = recipeRepository.findAll(); // 필요 시 페이징/샘플링로 개선
        Collections.shuffle(all, seeded);
        return all.stream().limit(PICK_SIZE).collect(Collectors.toList());
    }

    /**
     * 매일 0시에 시작 레시피 ID를 갱신하고,
     * 사용자별 일일 추천 캐시(UserDailyRecipe)는 초기화
     */
    @Scheduled(cron = "0 0 0 * * ?")
    @Transactional
    public void updateDailyIndex() {
        log.info("Daily recommendation update started at midnight");

        // 1) 모든 사용자 일일 추천 초기화
        userDailyRecipeRepository.deleteAll();
        log.info("Cleared all previous daily recommendations");

        // 2) DailyIndex 증가(윈도우 이동)
        DailyIndex index = dailyIndexRepository.findById(1L).orElseGet(() -> {
            DailyIndex d = new DailyIndex();
            d.setId(1L);
            d.setStartRecipeId(DEFAULT_START_ID);
            return d;
        });

        long current = (index.getStartRecipeId() == null) ? DEFAULT_START_ID : index.getStartRecipeId();
        long next = current + WINDOW_SIZE;
        if (next >= MAX_ID_EXCLUSIVE) {
            next = DEFAULT_START_ID; // 롤오버
        }

        index.setStartRecipeId(next);
        dailyIndexRepository.save(index);

        log.info("Daily index updated: {} -> {}", current, next);
    }

    // ===== 내부 유틸 =====

    /** 후보에서 중복 없이 size까지 채우기 */
    private void fillUpTo(List<Recipe> top, List<Recipe> pool, int size) {
        if (top.size() >= size || pool.isEmpty()) return;

        Set<String> selectedIds = top.stream().map(Recipe::getRecipeId).collect(Collectors.toSet());
        Collections.shuffle(pool); // 비결정적 보완 셔플
        for (Recipe r : pool) {
            if (top.size() >= size) break;
            if (selectedIds.add(r.getRecipeId())) {
                top.add(r);
            }
        }
    }

    /** 전체 DB에서 중복 없이 size까지 채우기 (성능 필요 시 페이지네이션으로 교체) */
    private void fillFromAll(List<Recipe> top, int size) {
        if (top.size() >= size) return;

        Set<String> selectedIds = top.stream().map(Recipe::getRecipeId).collect(Collectors.toSet());
        List<Recipe> all = recipeRepository.findAll();
        Collections.shuffle(all);
        for (Recipe r : all) {
            if (top.size() >= size) break;
            if (selectedIds.add(r.getRecipeId())) {
                top.add(r);
            }
        }
    }

    @AllArgsConstructor
    static class RecipeScore {
        Recipe recipe;
        int score;
    }

    /** 요약 DTO 변환 (스크랩 여부는 user==null이면 전부 false) */
    public List<RecipeSummaryDto> convertToSummaryDtos(User user, List<Recipe> recipes) {
        Set<String> scrappedIds = (user == null)
                ? Collections.emptySet()
                : new HashSet<>(recipeScrapRepository.findRecipeIdsByUserId(user.getUserId()));

        return recipes.stream().map(r -> {
            List<String> ingrNames = recipeIngredientRepository.findIngredientNamesByRecipeId(r.getRecipeId());
            return new RecipeSummaryDto(
                    r.getRecipeId(),
                    r.getName(),
                    ingrNames,
                    r.getDescription(),
                    r.getReview(),
                    r.getTime(),
                    r.getDifficulty(),
                    r.getPortion(),
                    r.getMethod(),
                    r.getMaterialType(),
                    r.getImageUrl(),
                    scrappedIds.contains(r.getRecipeId())
            );
        }).collect(Collectors.toList());
    }
}
