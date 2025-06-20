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
    private final RecipeScrapRepository recipeScrapRepository;

    @Transactional
    public List<Recipe> getDailyRecommendedRecipes(User user) {
        LocalDate today = LocalDate.now();

        // 1. 이미 저장된 추천 있으면 반환
        Optional<UserDailyRecipe> saved = userDailyRecipeRepository.findByUserAndDate(user, today);
        if (saved.isPresent()) {
            List<String> recipeIds = saved.get().getRecipeIds();
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
            if (topRecipes.size() >= 6) break;
            if (!selectedIds.contains(r.getRecipeId())) {
                topRecipes.add(r);
                selectedIds.add(r.getRecipeId());
            }
        }

        // 7. 그래도 부족하면 전체 DB에서 채움
        if (topRecipes.size() < 6) {
            List<Recipe> all = recipeRepository.findAll();  // 성능 주의
            Collections.shuffle(all);
            for (Recipe r : all) {
                if (topRecipes.size() >= 6) break;
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

    public List<RecipeSummaryDto> convertToSummaryDtos(User user, List<Recipe> recipes) {
        return recipes.stream().map(r -> {
            Set<String> scrappedIds = recipeScrapRepository
                    .findAllByUser(user)
                    .stream()
                    .map(scrap -> scrap.getRecipe().getRecipeId())
                    .collect(Collectors.toSet());

            List<String> ingrNames = recipeIngredientRepository
                    .findIngredientNamesByRecipeId(r.getRecipeId());

            boolean isScrapped = scrappedIds.contains(r.getRecipeId());

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
                    isScrapped
            );
        }).collect(Collectors.toList());
    }
}
