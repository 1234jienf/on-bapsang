package com.on_bapsang.backend.controller;

import com.on_bapsang.backend.dto.RecipeDetailDto;
import com.on_bapsang.backend.dto.RecommendRequest;
import com.on_bapsang.backend.dto.RecommendResponse;
import com.on_bapsang.backend.service.RecommendationService;
import com.on_bapsang.backend.service.RecipeService;
import com.on_bapsang.backend.service.RecipeService.PagedResponse;
import com.on_bapsang.backend.dto.RecipeSummaryDto;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/recipe")
@RequiredArgsConstructor
public class RecipeController {

    private final RecommendationService recommendationService;
    private final RecipeService recipeService;

    /** 외부 AI 추천 */
    @PostMapping("/foreign")
    public ResponseEntity<RecommendResponse> recommend(
            @Valid @RequestBody RecommendRequest request) {
        RecommendResponse resp = recommendationService.getRecommendations(request);
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
