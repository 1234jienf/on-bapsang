package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.IngredientDetailDto;
import com.on_bapsang.backend.dto.PostSummary;
import com.on_bapsang.backend.dto.RecipeDetailDto;
import com.on_bapsang.backend.dto.RecipeSummaryDto;
import com.on_bapsang.backend.entity.IngredientMaster;
import com.on_bapsang.backend.entity.Recipe;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.entity.RecipeScrap;
import com.on_bapsang.backend.exception.CustomException;
import com.on_bapsang.backend.repository.*;
import com.on_bapsang.backend.util.ImageUploader;
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
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RecipeService {
    private final RecipeRepository recipeRepository;
    private final RecipeIngredientRepository recipeIngredientRepository;
    private final RecipeScrapRepository recipeScrapRepository;
    private final PostRepository postRepository;
    private final IngredientMasterRepository ingredientMasterRepository;
    private final SearchKeywordService searchKeywordService;
    private final ImageUploader imageUploader;


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

    private Set<String> getScrappedIdsOrEmpty(User user) {
        if (user == null) return Collections.emptySet();
        return recipeScrapRepository.findAllByUser(user)
                .stream()
                .map(scrap -> scrap.getRecipe().getRecipeId())
                .collect(Collectors.toSet());
    }

    // RecipeService 내부
    private String toDisplayUrl(String stored, int ttlSec) {
        if (stored == null || stored.isBlank()) return null;

        // 이미 완전한 URL이면 그대로 반환 (공개 URL 정책)
        if (stored.startsWith("http://") || stored.startsWith("https://")) {
            return stored;
        }
        // 키로 간주하고 presign
        return imageUploader.generatePresignedUrl(stored, ttlSec);
    }

    /**
     * 상세 조회
     */
    public RecipeDetailDto getRecipeDetail(String recipeId, User user) {
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
        boolean isScrapped = (user == null) ? false : recipeScrapRepository.existsByUserAndRecipe(user, recipe);
        // 리뷰 presigned
        List<PostSummary> allReviews = postRepository.findPostSummariesByRecipeId(recipeId);
        for (PostSummary review : allReviews) {
            if (review.getImageUrl() != null) {
                review.setImageUrl(toDisplayUrl(review.getImageUrl(), 600));
            }
        }
        int reviewCount = allReviews.size();
        List<PostSummary> reviews = allReviews.stream().limit(9).toList();

        // ✅ 레시피 이미지 presigned 생성 후 DTO에 **그 값**을 넣어주기
        String imageUrl = toDisplayUrl(recipe.getImageUrl(), 600); // 테스트는 600~1800초 추천

        // ③ DTO 조립
        return new RecipeDetailDto(
                recipe.getRecipeId(),
                recipe.getName(),
                imageUrl,               // ← 기존에는 recipe.getImageUrl()를 그대로 넣고 있었음 (버그)
                recipe.getTime(),
                recipe.getDifficulty(),
                recipe.getPortion(),
                recipe.getMethod(),
                recipe.getMaterialType(),
                ingredients,
                steps,
                recipe.getReview(),
                recipe.getDescription(),
                isScrapped,
                reviews,
                reviewCount
        );

    }

    public PagedResponse<RecipeSummaryDto> getRecipesByPartialIngredientName(String partialName, User user, int page, int size) {
        List<IngredientMaster> ingredients = ingredientMasterRepository.findAllByNameContaining(partialName);

        if (ingredients.isEmpty()) {
            return new PagedResponse<>(new Meta(page, false), List.of());
        }

        // 재료 ID 추출
        List<Long> ingredientIds = ingredients.stream()
                .map(IngredientMaster::getIngredientId)
                .toList();

        // 모든 재료에 대한 recipeId 조회 후 중복 제거
        Set<String> recipeIds = ingredientIds.stream()
                .flatMap(id -> recipeIngredientRepository.findRecipeIdsByIngredientId(id).stream())
                .collect(Collectors.toSet());

        if (recipeIds.isEmpty()) {
            return new PagedResponse<>(new Meta(page, false), List.of());
        }

        // 페이징 수동 처리
        List<String> recipeIdList = recipeIds.stream().toList();
        int from = page * size;
        if (from >= recipeIdList.size()) return new PagedResponse<>(new Meta(page, false), List.of());

        int to = Math.min(from + size, recipeIdList.size());
        List<Recipe> recipes = recipeRepository.findAllById(recipeIdList.subList(from, to));
        List<RecipeSummaryDto> summaries = convertToSummaryDtos(user, recipes);

        boolean hasMore = to < recipeIdList.size();
        return new PagedResponse<>(new Meta(page, hasMore), summaries);
    }




    private List<RecipeSummaryDto> convertToSummaryDtos(User user, List<Recipe> recipes) {
        Set<String> scrappedIds = getScrappedIdsOrEmpty(user); // ✅ null-safe

        return recipes.stream().map(r -> {
            List<String> ingrNames = recipeIngredientRepository.findIngredientNamesByRecipeId(r.getRecipeId());
            boolean isScrapped = scrappedIds.contains(r.getRecipeId());

            String presigned = toDisplayUrl(r.getImageUrl(), 600);

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
                    presigned,         // ✅ 목록용도 presigned 써주면 UX 좋아짐
                    isScrapped
            );
        }).collect(Collectors.toList());
    }


    public List<Recipe> getRecipesByIngredientName(String prdlstNm) {
        IngredientMaster ingredient = ingredientMasterRepository
                .findByNameContaining(prdlstNm)
                .orElse(null);

        if (ingredient == null) {
            return List.of();  // 🔥 재료가 없으면 빈 리스트
        }

        List<String> recipeIds = recipeIngredientRepository.findRecipeIdsByIngredientId(ingredient.getIngredientId());
        if (recipeIds.isEmpty()) {
            return List.of();  // 🔥 연결된 레시피도 없으면 빈 리스트
        }

        return recipeRepository.findAllById(recipeIds);
    }


    public List<RecipeSummaryDto> getRecipeDtosByIngredient(String prdlstNm, User user) {
        List<Recipe> recipes = getRecipesByIngredientName(prdlstNm);
        return convertToSummaryDtos(user, recipes);  // 기존 로직 재사용
    }


    public List<PostSummary> getAllReviewsForRecipe(String recipeId) {
        List<PostSummary> reviews = postRepository.findPostSummariesByRecipeId(recipeId);
        for (PostSummary review : reviews) {
            if (review.getImageUrl() != null) {
                review.setImageUrl(toDisplayUrl(review.getImageUrl(), 600));
            }
        }
        return reviews;
    }



    public void addScrap(User user, String recipeId) {
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(() -> new CustomException("레시피가 존재하지 않습니다.", HttpStatus.NOT_FOUND));

        if (recipeScrapRepository.existsByUserAndRecipe(user, recipe)) {
            throw new CustomException("이미 스크랩한 레시피입니다.", HttpStatus.CONFLICT);
        }

        RecipeScrap scrap = new RecipeScrap();
        scrap.setUser(user);
        scrap.setRecipe(recipe);
        recipeScrapRepository.save(scrap);
    }

    public void removeScrap(User user, String recipeId) {
        Recipe recipe = recipeRepository.findById(recipeId)
                .orElseThrow(() -> new CustomException("레시피가 존재하지 않습니다.", HttpStatus.NOT_FOUND));

        RecipeScrap scrap = recipeScrapRepository.findByUserAndRecipe(user, recipe)
                .orElseThrow(() -> new CustomException("스크랩하지 않은 레시피입니다.", HttpStatus.BAD_REQUEST));

        recipeScrapRepository.delete(scrap);
    }

    /**
     * 이름으로 검색 (페이징)
     */
    public PagedResponse<RecipeSummaryDto> getRecipesByName(User user, String name, int page, int size) {
        if (name == null || name.isBlank() || page < 0 || size <= 0) {
            throw new CustomException("잘못된 요청입니다.", HttpStatus.BAD_REQUEST);
        }

        // ✅ 게스트면 recent keyword 저장 생략
        if (user != null) {
            searchKeywordService.saveRecentKeyword(user.getUserId(), name);
        }
        // 인기 검색어 점수는 게스트도 올릴지 정책에 따라 결정 (유지)
        searchKeywordService.increaseKeywordScore(name);

        Pageable pg = PageRequest.of(page, size);
        Page<Recipe> recipePage = recipeRepository.findByNameContaining(name.trim(), pg);

        if (recipePage.isEmpty()) {
            throw new CustomException("일치하는 레시피가 존재하지 않습니다.", HttpStatus.NOT_FOUND);
        }

        Set<String> scrappedIds = getScrappedIdsOrEmpty(user); // ✅ null-safe

        List<RecipeSummaryDto> summaries = recipePage.getContent().stream()
                .map(r -> {
                    List<String> ingrNames = recipeIngredientRepository
                            .findIngredientNamesByRecipeId(r.getRecipeId());
                    boolean isScrapped = scrappedIds.contains(r.getRecipeId());

                    String presigned = toDisplayUrl(r.getImageUrl(), 600);


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
                            presigned,   // ✅
                            isScrapped
                    );
                })
                .collect(Collectors.toList());

        Meta meta = new Meta(recipePage.getNumber(), recipePage.hasNext());
        return new PagedResponse<>(meta, summaries);
    }


    // ② 카테고리 검색 + 페이징
    public PagedResponse<RecipeSummaryDto> getRecipesByCategory(User user, String category, int page, int size) {
        if (category == null || category.isBlank() || page < 0 || size <= 0) {
            throw new CustomException("잘못된 요청입니다.", HttpStatus.BAD_REQUEST);
        }

        Pageable pg = PageRequest.of(page, size);
        Page<Recipe> recipePage = recipeRepository.findByMaterialTypeContaining(category.trim(), pg);

        if (recipePage.isEmpty()) {
            throw new CustomException("일치하는 레시피가 존재하지 않습니다.", HttpStatus.NOT_FOUND);
        }

        Set<String> scrappedIds = getScrappedIdsOrEmpty(user); // ✅ null-safe

        List<RecipeSummaryDto> summaries = recipePage.getContent().stream()
                .map(r -> {
                    List<String> ingrNames = recipeIngredientRepository.findIngredientNamesByRecipeId(r.getRecipeId());
                    boolean isScrapped = scrappedIds.contains(r.getRecipeId());

                    String presigned = toDisplayUrl(r.getImageUrl(), 600);


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
                            presigned,  // ✅
                            isScrapped
                    );
                })
                .collect(Collectors.toList());

        Meta meta = new Meta(recipePage.getNumber(), recipePage.hasNext());
        return new PagedResponse<>(meta, summaries);
    }

}