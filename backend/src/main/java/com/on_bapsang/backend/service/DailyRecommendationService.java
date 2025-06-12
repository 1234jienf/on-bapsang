package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.RecipeSummaryDto;
import com.on_bapsang.backend.entity.DailyIndex;
import com.on_bapsang.backend.entity.Recipe;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.repository.*;
import jakarta.transaction.Transactional;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
@Service
@RequiredArgsConstructor
public class DailyRecommendationService {

    private final RecipeRepository recipeRepository;
    private final RecipeIngredientRepository recipeIngredientRepository;
    private final UserFavoriteDishRepository userFavoriteDishRepository;
    private final UserFavoriteIngredientRepository userFavoriteIngredientRepository;
    private final DailyIndexRepository dailyIndexRepository;

    public List<Recipe> getDailyRecommendedRecipes(User user) {
        // 1. 오늘의 시작 지점 확인
        DailyIndex index = dailyIndexRepository.findById(1L)
                .orElseGet(() -> new DailyIndex());

        Long startId = index.getStartRecipeId() == null ? 7016813L : index.getStartRecipeId();
        Long endId = startId + 100;

        // 2. 유저 선호 재료와 음식명 불러오기
        List<Long> ingredientIds = userFavoriteIngredientRepository.findIngredientIdsByUser(user);
        List<String> dishNames = userFavoriteDishRepository.findDishNamesByUser(user);

        // 3. 100개 중 유사도 점수 계산
        List<Recipe> candidates = recipeRepository.findByRecipeIdBetween(startId, endId);
        List<RecipeScore> scored = new ArrayList<>();

        for (Recipe recipe : candidates) {
            int score = 0;

            // 음식명 일치 여부
            if (dishNames.contains(recipe.getName())) {
                score += 2;
            }

            // 재료 일치 개수 세기
            List<Long> recipeIngreIds = recipeIngredientRepository.findIngredientIdsByRecipe(recipe.getRecipeId());
            for (Long ingId : recipeIngreIds) {
                if (ingredientIds.contains(ingId)) {
                    score += 1;
                }
            }

            scored.add(new RecipeScore(recipe, score));
        }

        // 4. 점수 기준으로 내림차순 정렬 후 상위 6개 리턴
        scored.sort((a, b) -> b.score - a.score);
        return scored.stream().limit(6).map(rs -> rs.recipe).toList();
    }

    // 5. 하루마다 실행되는 자동 증가 로직 (스케줄러)
    @Scheduled(cron = "0 0 0 * * ?")  // 매일 자정
    @Transactional
    public void updateDailyIndex() {
        DailyIndex index = dailyIndexRepository.findById(1L)
                .orElseGet(() -> new DailyIndex());

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
