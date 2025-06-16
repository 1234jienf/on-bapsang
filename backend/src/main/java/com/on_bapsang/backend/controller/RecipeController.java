package com.on_bapsang.backend.controller;

import com.on_bapsang.backend.dto.*;
import com.on_bapsang.backend.entity.Recipe;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.security.UserDetailsImpl;
import com.on_bapsang.backend.service.DailyRecommendationService;
import com.on_bapsang.backend.service.PopularRecipeService;
import com.on_bapsang.backend.service.RecommendationService;
import com.on_bapsang.backend.service.RecipeService;
import com.on_bapsang.backend.service.RecipeService.PagedResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/recipe")
@RequiredArgsConstructor
public class RecipeController {

    private final RecommendationService recommendationService;
    private final RecipeService recipeService;
    private final DailyRecommendationService dailyRecommendationService;
    private final PopularRecipeService popularRecipeService;


    @GetMapping("/recommend")
    public ResponseEntity<?> getRecommendedRecipes(@AuthenticationPrincipal UserDetailsImpl user) {
        try {
            List<Recipe> recipes = dailyRecommendationService.getDailyRecommendedRecipes(user.getUser());
            List<RecipeSummaryDto> dtos = dailyRecommendationService.convertToSummaryDtos(recipes);
            return ResponseEntity.ok(dtos);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "서버 내부 오류가 발생했습니다."));
        }
    }


    @GetMapping("/popular")
    public ResponseEntity<List<PopularRecipeDto>> getPopularRecipes() {
        return ResponseEntity.ok(popularRecipeService.getPopularRecipes());
    }



    /** 외부 AI 추천 */
    /** 외부 AI 추천 + 페이지네이션 */
    @PostMapping("/foreign")
    public ResponseEntity<RecommendResponse> recommend(
            @Valid @RequestBody RecommendRequest request,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {

        RecommendResponse resp = recommendationService.getRecommendations(request, page, size);
        return ResponseEntity.status(HttpStatus.CREATED).body(resp);
    }

    /** 상세 조회 */
    @GetMapping("/foreign/{recipeId}")
    public ResponseEntity<RecipeDetailDto> getRecipeDetail(
            @PathVariable String recipeId) {
        RecipeDetailDto detail = recipeService.getRecipeDetail(recipeId);
        return ResponseEntity.ok(detail);
    }

    @GetMapping("/search")
    public ResponseEntity<RecipeService.PagedResponse<RecipeSummaryDto>> searchByName(
            @RequestParam("name") String name,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {
        return ResponseEntity.ok(recipeService.getRecipesByName(name, page, size));
    }

    @GetMapping
    public ResponseEntity<RecipeService.PagedResponse<RecipeSummaryDto>> searchByCategory(
            @RequestParam("category") String category,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {
        return ResponseEntity.ok(recipeService.getRecipesByCategory(category, page, size));
    }

}
