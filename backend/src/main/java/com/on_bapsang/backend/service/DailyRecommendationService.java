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
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DailyRecommendationService {

    private final RecipeRepository recipeRepository;
    private final RecipeIngredientRepository recipeIngredientRepository;
    private final UserFavoriteDishRepository userFavoriteDishRepository;
    private final UserFavoriteIngredientRepository userFavoriteIngredientRepository;
    private final DailyIndexRepository dailyIndexRepository;
    private final UserDailyRecipeRepository userDailyRecipeRepository;

    @Transactional(readOnly = true)
    public List<Recipe> getDailyRecommendedRecipes(User user) {
        LocalDate today = LocalDate.now();

        // 1. 이미 저장된 추천이 있으면 반환
        Optional<UserDailyRecipe> saved = userDailyRecipeRepository.findByUserAndDate(user, today);
        if (saved.isPresent()) {
            List<String> recipeIds = saved.get().getRecipeIds();
            return recipeRepository.findAllById(recipeIds);
        }

        // 2. 오늘의 시작 ID 구간 확인
        DailyIndex index = dailyIndexRepository.findById(1L).orElseGet(DailyIndex::new);
        Long startId = index.getStartRecipeId() == null ? 7016813L : index.getStartRecipeId();
        Long endId = startId + 100;

        // 3. 유저 선호 정보 조회
        List<Long> ingredientIds = userFavoriteIngredientRepository.findIngredientIdsByUser(user);
        List<String> dishNames = userFavoriteDishRepository.findDishNamesByUser(user);

        // 4. 후보 레시피 추출
        List<Recipe> candidates = recipeRepository.findByRecipeIdBetween(startId, endId);

        // 5. 점수 계산
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
                score += (int) (similarity * 10); // 최대 10점
            }

            scored.add(new RecipeScore(recipe, score));
        }

        // 6. 점수 높은 순으로 정렬
        List<Recipe> topRecipes = scored.stream()
                .filter(rs -> rs.score > 0)
                .sorted((a, b) -> Integer.compare(b.score, a.score))
                .limit(6)
                .map(rs -> rs.recipe)
                .collect(Collectors.toList());

        // 7. fallback: 점수 0이면 랜덤 6개
        if (topRecipes.isEmpty()) {
            Collections.shuffle(candidates);
            topRecipes = candidates.stream().limit(6).collect(Collectors.toList());
        }

        // 8. 추천 결과 저장 (존재하는 ID만 저장)
        List<String> topRecipeIds = topRecipes.stream()
                .map(Recipe::getRecipeId)
                .filter(id -> recipeRepository.existsById(id))  // 필수 안전장치
                .collect(Collectors.toList());

        // 저장 전 유효성 체크
        if (!topRecipeIds.isEmpty()) {
            UserDailyRecipe newEntry = new UserDailyRecipe();
            newEntry.setUser(user);
            newEntry.setDate(today);
            newEntry.setRecipeIds(topRecipeIds);
            userDailyRecipeRepository.save(newEntry);
        }

        return topRecipes;
    }

    // 하루마다 시작 레시피 ID 갱신
    @Scheduled(cron = "0 0 0 * * ?")
    @Transactional
    public void updateDailyIndex() {
        DailyIndex index = dailyIndexRepository.findById(1L).orElseGet(DailyIndex::new);

        long maxId = 7038813L; // 예시
        long next = index.getStartRecipeId() + 100;
        if (next > maxId) next = 7016813L;

        index.setStartRecipeId(next);
        dailyIndexRepository.save(index);
    }

    @AllArgsConstructor
    static class RecipeScore {
        Recipe recipe;
        int score;
    }

    public List<RecipeSummaryDto> convertToSummaryDtos(List<Recipe> recipes) {
        return recipes.stream().map(r -> {
            List<String> ingrNames = recipeIngredientRepository
                    .findIngredientNamesByRecipeId(r.getRecipeId());

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
                    r.getImageUrl()
            );
        }).collect(Collectors.toList());
    }
}
