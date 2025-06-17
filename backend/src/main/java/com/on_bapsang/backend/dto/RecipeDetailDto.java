package com.on_bapsang.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;
@Data
@AllArgsConstructor
public class RecipeDetailDto {
    @JsonProperty("recipe_id")
    private String recipeId;

    private String name;

    @JsonProperty("image_url")
    private String imageUrl;

    private String time;
    private String difficulty;
    private String portion;
    private String method;

    @JsonProperty("material_type")
    private String materialType;

    // 상세 재료: id, 이름, 분량
    private List<IngredientDetailDto> ingredients;

    // 순서에 맞춘 조리 순서(문장)
    private List<String> instruction;

    private String review;
    private String descriptions;
    private boolean isScrapped;
    private List<PostSummary> reviews;
    private int reviewCount;
}
