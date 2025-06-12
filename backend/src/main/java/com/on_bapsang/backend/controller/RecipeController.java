package com.on_bapsang.backend.controller;

import com.on_bapsang.backend.dto.RecipeDetailDto;
import com.on_bapsang.backend.dto.RecommendRequest;
import com.on_bapsang.backend.dto.RecommendResponse;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.security.UserDetailsImpl;
import com.on_bapsang.backend.service.DailyRecommendationService;
import com.on_bapsang.backend.service.RecommendationService;
import com.on_bapsang.backend.service.RecipeService;
import com.on_bapsang.backend.service.RecipeService.PagedResponse;
import com.on_bapsang.backend.dto.RecipeSummaryDto;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/recipe")
@RequiredArgsConstructor
public class RecipeController {

    private final RecommendationService recommendationService;
    private final RecipeService recipeService;
    private final DailyRecommendationService dailyRecommendationService;


    @GetMapping("/recommend")
    public ResponseEntity<List<RecipeSummaryDto>> recommendDailyRecipes(
            @AuthenticationPrincipal UserDetailsImpl userDetails
    ) {
        User user = userDetails.getUser();
        List<RecipeSummaryDto> result = dailyRecommendationService
                .convertToSummaryDtos(
                        dailyRecommendationService.getDailyRecommendedRecipes(user)
                );
        return ResponseEntity.ok(result);
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
