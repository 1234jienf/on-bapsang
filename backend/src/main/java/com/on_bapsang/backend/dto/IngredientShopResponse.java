package com.on_bapsang.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.on_bapsang.backend.i18n.Translatable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

import java.util.List;

@Data
@AllArgsConstructor
public class IngredientShopResponse {

  @Getter
  @AllArgsConstructor
  public static class Meta {
    private int currentPage; // 현재 페이지 번호
    private boolean hasMore; // 다음 페이지 여부
  }

  @Getter
  @AllArgsConstructor
  public static class IngredientInfo {
    @JsonProperty("ingredient_id")
    private Long ingredientId;

    @Translatable
    private String name;

    @JsonProperty("image_url")
    private String imageUrl;

    @Translatable
    private String category;

    private String price;
    private String unit;
  }

  // 페이징 메타 정보
  private Meta meta;

  // 재료 기본 정보
  @JsonProperty("ingredient_info")
  private IngredientInfo ingredientInfo;

  // 관련 레시피들
  @JsonProperty("related_recipes")
  private List<RecipeSummaryDto> relatedRecipes;
}