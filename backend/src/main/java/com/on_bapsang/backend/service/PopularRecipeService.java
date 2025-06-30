package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.PopularRecipeDto;
import com.on_bapsang.backend.dto.RecipeSummaryDto;
import com.on_bapsang.backend.entity.Recipe;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.PageRequest;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PopularRecipeService {

    private final PostRepository postRepository;
    private final RecipeRepository recipeRepository;
    private final RecipeIngredientRepository recipeIngredientRepository;
    private final RecipeScrapRepository recipeScrapRepository;

    public List<PopularRecipeDto> getPopularRecipes(User user) {
        Pageable limit6 = PageRequest.of(0, 6);
        List<Object[]> result = postRepository.findTopRecipeIdsByPostCount(limit6);

        Set<String> scrappedIds = (user == null)
                ? Collections.emptySet()
                : new HashSet<>(recipeScrapRepository
                .findRecipeIdsByUserId(user.getUserId()));

        List<PopularRecipeDto> summaries = new ArrayList<>();
        for (Object[] row : result) {
            String recipeId = (String) row[0];
            Long count = (Long) row[1];

            Recipe recipe = recipeRepository.findById(recipeId).orElse(null);
            if (recipe == null)
                continue;

            List<String> ingrNames = recipeIngredientRepository.findIngredientNamesByRecipeId(recipeId);

            summaries.add(new PopularRecipeDto(
                    recipe.getRecipeId(),
                    recipe.getName(),
                    ingrNames,
                    recipe.getDescription(),
                    recipe.getReview(),
                    recipe.getTime(),
                    recipe.getDifficulty(),
                    recipe.getPortion(),
                    recipe.getMethod(),
                    recipe.getMaterialType(),
                    recipe.getImageUrl(),
                    count.intValue(),
                    scrappedIds.contains(recipeId)
            ));
        }

        return summaries;
    }
}
