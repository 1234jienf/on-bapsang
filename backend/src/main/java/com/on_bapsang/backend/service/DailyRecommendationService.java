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

    private final RecipeRepository recipeRepository;
    private final RecipeIngredientRepository recipeIngredientRepository;
    private final UserFavoriteDishRepository userFavoriteDishRepository;
    private final UserFavoriteIngredientRepository userFavoriteIngredientRepository;
    private final DailyIndexRepository dailyIndexRepository;
    private final UserDailyRecipeRepository userDailyRecipeRepository;
    private final RecipeScrapRepository recipeScrapRepository;

    @Transactional
    public List<Recipe> getDailyRecommendedRecipes(User user) {
        LocalDate today = LocalDate.now();

        // 1. 이미 저장된 추천 있으면 반환
        List<UserDailyRecipe> savedList = userDailyRecipeRepository.findByUserAndDate(user, today);
        if (!savedList.isEmpty()) {
            UserDailyRecipe first = savedList.get(0); // 여러 개 있으면 첫 번째 것만 씀
            List<String> recipeIds = first.getRecipeIds();
            return recipeRepository.findAllById(recipeIds);
        }

        // 2. 시작 ID 범위
        DailyIndex index = dailyIndexRepository.findById(1L).orElseGet(DailyIndex::new);
        Long startId = index.getStartRecipeId() == null ? 7016813L : index.getStartRecipeId();
        Long endId = startId + 100;

        // 3. 유저 선호 정보
        List<Long> ingredientIds = userFavoriteIngredientRepository.findIngredientIdsByUser(user);
        List<String> dishNames = userFavoriteDishRepository.findDishNamesByUser(user);

        // 4. 후보 레시피
        List<Recipe> candidates = recipeRepository.findByRecipeIdBetween(startId, endId);
        List<RecipeScore> scored = new ArrayList<>();

        for (Recipe recipe : candidates) {
            int score = 0;

            for (String dishName : dishNames) {
                if (recipe.getName().equalsIgnoreCase(dishName)) {
                    score += 3;
                } else if (recipe.getName().contains(dishName)) {
                    score += 1;
                }
            }

            List<Long> recipeIngreIds = recipeIngredientRepository.findIngredientIdsByRecipe(recipe.getRecipeId());
            if (!recipeIngreIds.isEmpty()) {
                long matchCount = recipeIngreIds.stream().filter(ingredientIds::contains).count();
                double similarity = (double) matchCount / recipeIngreIds.size();
                score += (int) (similarity * 10);
            }

            scored.add(new RecipeScore(recipe, score));
        }

        // 5. 점수 높은 순
        List<Recipe> topRecipes = scored.stream()
                .filter(rs -> rs.score > 0)
                .sorted((a, b) -> Integer.compare(b.score, a.score))
                .limit(6)
                .map(rs -> rs.recipe)
                .collect(Collectors.toList());

        // 6. 부족하면 후보군에서 추가
        Set<String> selectedIds = topRecipes.stream().map(Recipe::getRecipeId).collect(Collectors.toSet());
        Collections.shuffle(candidates);
        for (Recipe r : candidates) {
            if (topRecipes.size() >= 6)
                break;
            if (!selectedIds.contains(r.getRecipeId())) {
                topRecipes.add(r);
                selectedIds.add(r.getRecipeId());
            }
        }

        // 7. 그래도 부족하면 전체 DB에서 채움
        if (topRecipes.size() < 6) {
            List<Recipe> all = recipeRepository.findAll(); // 성능 주의
            Collections.shuffle(all);
            for (Recipe r : all) {
                if (topRecipes.size() >= 6)
                    break;
                if (!selectedIds.contains(r.getRecipeId())) {
                    topRecipes.add(r);
                    selectedIds.add(r.getRecipeId());
                }
            }
        }

        // 8. 저장
        List<String> topRecipeIds = topRecipes.stream()
                .map(Recipe::getRecipeId)
                .collect(Collectors.toList());

        UserDailyRecipe entry = new UserDailyRecipe();
        entry.setUser(user);
        entry.setDate(today);
        entry.setRecipeIds(topRecipeIds);
        userDailyRecipeRepository.save(entry);

        return topRecipes;
    }

    // 하루마다 시작 레시피 ID 갱신
    @Scheduled(cron = "0 0 0 * * ?")
    @Transactional
    public void updateDailyIndex() {
        log.info("Daily recommendation update started at midnight");

        // 기존 모든 사용자의 일일 추천 데이터 삭제 (새로운 추천을 위해)
        userDailyRecipeRepository.deleteAll();
        log.info("Cleared all previous daily recommendations");

        DailyIndex index = dailyIndexRepository.findById(1L).orElseGet(() -> {
            DailyIndex newIndex = new DailyIndex();
            newIndex.setId(1L);
            newIndex.setStartRecipeId(7016813L);
            return newIndex;
        });

        long maxId = 7038813L; // 예시
        Long currentStartId = index.getStartRecipeId();
        if (currentStartId == null) {
            currentStartId = 7016813L;
        }

        long next = currentStartId + 100;
        if (next > maxId) {
            next = 7016813L;
        }

        index.setStartRecipeId(next);
        dailyIndexRepository.save(index);

        log.info("Daily index updated: {} -> {}", currentStartId, next);
    }

    @AllArgsConstructor
    static class RecipeScore {
        Recipe recipe;
        int score;
    }

    public List<RecipeSummaryDto> convertToSummaryDtos(User user, List<Recipe> recipes) {

        Set<String> scrappedIds = (user == null)
                ? Collections.emptySet()
                : new HashSet<>(recipeScrapRepository
                        .findRecipeIdsByUserId(user.getUserId())); // ★ ID 기반

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
                    scrappedIds.contains(r.getRecipeId()) // ★ O(1) 체크
            );
        }).collect(Collectors.toList());
    }
}