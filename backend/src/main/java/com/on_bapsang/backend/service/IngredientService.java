package com.on_bapsang.backend.service;

import com.on_bapsang.backend.config.IngredientDataLoader;
import com.on_bapsang.backend.dto.IngredientInfo;
import com.on_bapsang.backend.dto.IngredientShopResponse;
import com.on_bapsang.backend.dto.RecipeSummaryDto;
import com.on_bapsang.backend.entity.IngredientMaster;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.exception.CustomException;
import com.on_bapsang.backend.repository.IngredientMasterRepository;
import com.on_bapsang.backend.repository.RecipeIngredientRepository;
import com.on_bapsang.backend.repository.RecipeRepository;
import com.on_bapsang.backend.repository.RecipeScrapRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class IngredientService {

  private final IngredientDataLoader ingredientDataLoader;
  private final IngredientMasterRepository ingredientMasterRepository;
  private final RecipeIngredientRepository recipeIngredientRepository;
  private final RecipeRepository recipeRepository;
  private final RecipeScrapRepository recipeScrapRepository;

  public IngredientShopResponse getIngredientWithRelatedRecipes(Long ingredientId, User user, int page, int size) {
    // 1. 더미 데이터에서 재료 정보 조회
    IngredientInfo ingredientInfo = ingredientDataLoader.getInfo(ingredientId);
    if (ingredientInfo == null) {
      throw new CustomException("재료를 찾을 수 없습니다.", HttpStatus.NOT_FOUND);
    }

    // 2. IngredientMaster에서 동일한 이름의 재료 찾기
    IngredientMaster ingredientMaster = ingredientMasterRepository.findByName(ingredientInfo.getIngredientName())
        .orElse(null);

    if (ingredientMaster == null) {
      // 관련 레시피가 없는 경우
      IngredientShopResponse.IngredientInfo responseIngredientInfo = new IngredientShopResponse.IngredientInfo(
          ingredientInfo.getIngredientId(),
          ingredientInfo.getIngredientName(),
          ingredientInfo.getImageUrl(),
          ingredientInfo.getCategory(),
          ingredientInfo.getSalePrice() + "원",
          "개" // 기본 단위
      );

      IngredientShopResponse.Meta meta = new IngredientShopResponse.Meta(page, false);

      return new IngredientShopResponse(meta, responseIngredientInfo, List.of());
    }

    // 3. 관련 레시피 ID들 조회
    List<String> allRecipeIds = recipeIngredientRepository
        .findRecipeIdsByIngredientId(ingredientMaster.getIngredientId());

    if (allRecipeIds.isEmpty()) {
      // 관련 레시피가 없는 경우
      IngredientShopResponse.IngredientInfo responseIngredientInfo = new IngredientShopResponse.IngredientInfo(
          ingredientInfo.getIngredientId(),
          ingredientInfo.getIngredientName(),
          ingredientInfo.getImageUrl(),
          ingredientInfo.getCategory(),
          ingredientInfo.getSalePrice() + "원",
          "개" // 기본 단위
      );

      IngredientShopResponse.Meta meta = new IngredientShopResponse.Meta(page, false);

      return new IngredientShopResponse(meta, responseIngredientInfo, List.of());
    }

    // 4. 페이징 처리
    int from = page * size;
    if (from >= allRecipeIds.size()) {
      throw new CustomException("요청 페이지 범위를 초과했습니다.", HttpStatus.BAD_REQUEST);
    }

    int to = Math.min(from + size, allRecipeIds.size());
    List<String> pagedRecipeIds = allRecipeIds.subList(from, to);

    // 5. 스크랩 정보 조회 (사용자가 인증되지 않은 경우 빈 Set)
    Set<String> scrappedIds = (user != null)
        ? recipeScrapRepository.findAllByUser(user).stream()
            .map(scrap -> scrap.getRecipe().getRecipeId())
            .collect(Collectors.toSet())
        : Set.of(); // 인증되지 않은 사용자는 빈 Set

    // 6. 레시피 정보 조회 및 DTO 변환
    List<RecipeSummaryDto> relatedRecipes = recipeRepository.findAllById(pagedRecipeIds)
        .stream()
        .map(recipe -> {
          List<String> ingredientNames = recipeIngredientRepository
              .findIngredientNamesByRecipeId(recipe.getRecipeId());
          boolean isScrapped = scrappedIds.contains(recipe.getRecipeId());

          return new RecipeSummaryDto(
              recipe.getRecipeId(),
              recipe.getName(),
              ingredientNames,
              recipe.getDescription(),
              recipe.getReview(),
              recipe.getTime(),
              recipe.getDifficulty(),
              recipe.getPortion(),
              recipe.getMethod(),
              recipe.getMaterialType(),
              recipe.getImageUrl(),
              isScrapped);
        })
        .collect(Collectors.toList());

    // 7. 응답 구성
    IngredientShopResponse.IngredientInfo responseIngredientInfo = new IngredientShopResponse.IngredientInfo(
        ingredientInfo.getIngredientId(),
        ingredientInfo.getIngredientName(),
        ingredientInfo.getImageUrl(),
        ingredientInfo.getCategory(),
        ingredientInfo.getSalePrice() + "원",
        "개" // 기본 단위
    );

    boolean hasMore = to < allRecipeIds.size();
    IngredientShopResponse.Meta meta = new IngredientShopResponse.Meta(page, hasMore);

    return new IngredientShopResponse(meta, responseIngredientInfo, relatedRecipes);
  }
}