package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.IngredientDetailDto;
import com.on_bapsang.backend.dto.RecipeDetailDto;
import com.on_bapsang.backend.dto.RecipeSummaryDto;
import com.on_bapsang.backend.entity.Recipe;
import com.on_bapsang.backend.exception.CustomException;
import com.on_bapsang.backend.repository.RecipeIngredientRepository;
import com.on_bapsang.backend.repository.RecipeRepository;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RecipeService {
    private final RecipeRepository recipeRepository;
    private final RecipeIngredientRepository recipeIngredientRepository;

    @Getter
    @AllArgsConstructor
    public static class Meta {
        private int currentPage; // 현재 페이지 번호
        private boolean hasMore; // 다음 페이지 여부
    }

    @Getter
    @AllArgsConstructor
    public static class PagedResponse<T> {
        private Meta meta; // 페이징 메타 정보
        private List<T> data; // 실제 데이터 리스트
    }

    /**
     * 상세 조회
     */
    public RecipeDetailDto getRecipeDetail(String recipeId) {
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(() -> new CustomException("레시피를 찾을 수 없습니다.", HttpStatus.NOT_FOUND));

        // ① 재료 매핑
        List<IngredientDetailDto> ingredients = recipeIngredientRepository
                .findByRecipeId(recipeId)
                .stream()
                .map(rel -> {
                    var im = rel.getIngredientMaster();
                    return new IngredientDetailDto(
                            im.getIngredientId().toString(),
                            im.getName(),
                            rel.getAmount());
                })
                .collect(Collectors.toList());

        // ② instruction 텍스트를 번호별로 분리
        String raw = recipe.getInstruction();
        List<String> steps = Collections.emptyList();
        if (raw != null && !raw.isBlank()) {
            steps = Arrays.stream(raw.split("\\r?\\n"))
                    .map(String::trim)
                    .filter(s -> s.matches("^\\d+\\..+")) // "1. …" 형태만
                    .map(s -> s.replaceFirst("^\\d+\\.\\s*", "")) // "1. " 제거
                    .collect(Collectors.toList());
        }

        // ③ DTO 조립
        return new RecipeDetailDto(
                recipe.getRecipeId(),
                recipe.getName(),
                recipe.getImageUrl(),
                recipe.getTime(),
                recipe.getDifficulty(),
                recipe.getPortion(),
                recipe.getMethod(),
                recipe.getMaterialType(),
                ingredients,
                steps,
                recipe.getReview(),
                recipe.getDescription());
    }

    /**
     * 이름으로 검색 (페이징)
     */
    public PagedResponse<RecipeSummaryDto> getRecipesByName(String name, int page, int size) {
        if (name == null || name.isBlank() || page < 0 || size <= 0) {
            throw new CustomException("잘못된 요청입니다.", HttpStatus.BAD_REQUEST);
        }
        Pageable pg = PageRequest.of(page, size);
        Page<Recipe> recipePage = recipeRepository.findByNameContaining(name.trim(), pg);

        if (recipePage.isEmpty()) {
            throw new CustomException("일치하는 레시피가 존재하지 않습니다.", HttpStatus.NOT_FOUND);
        }

        List<RecipeSummaryDto> summaries = recipePage.getContent().stream()
                .map(r -> {
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
                            r.getImageUrl());
                })
                .collect(Collectors.toList());

        Meta meta = new Meta(recipePage.getNumber(), recipePage.hasNext());
        return new PagedResponse<>(meta, summaries);
    }

    // ② 카테고리 검색 + 페이징
    public PagedResponse<RecipeSummaryDto> getRecipesByCategory(String category, int page, int size) {
        if (category == null || category.isBlank() || page < 0 || size <= 0) {
            throw new CustomException("잘못된 요청입니다.", HttpStatus.BAD_REQUEST);
        }
        Pageable pg = PageRequest.of(page, size);
        Page<Recipe> recipePage = recipeRepository.findByMaterialTypeContaining(category.trim(), pg);

        if (recipePage.isEmpty()) {
            throw new CustomException("일치하는 레시피가 존재하지 않습니다.", HttpStatus.NOT_FOUND);
        }

        List<RecipeSummaryDto> summaries = recipePage.getContent().stream()
                .map(r -> {
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
                            r.getImageUrl());
                })
                .collect(Collectors.toList());

        Meta meta = new Meta(recipePage.getNumber(), recipePage.hasNext());
        return new PagedResponse<>(meta, summaries);
    }
}