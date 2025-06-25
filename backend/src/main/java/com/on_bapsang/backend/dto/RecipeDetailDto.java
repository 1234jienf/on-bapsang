package com.on_bapsang.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.on_bapsang.backend.i18n.Translatable;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class RecipeDetailDto {

    @JsonProperty("recipe_id")
    private String recipeId;

    @Translatable
    private String name;

    @JsonProperty("image_url")
    private String imageUrl;

    @Translatable
    private String time;

    @Translatable
    private String difficulty;

    @Translatable
    private String portion;

    @Translatable
    private String method;

    @Translatable
    @JsonProperty("material_type")
    private String materialType;

    private List<IngredientDetailDto> ingredients;

    @Translatable
    private List<String> instruction;

    @Translatable
    private String review;

    @Translatable
    private String descriptions;

    private boolean isScrapped;

    private List<PostSummary> reviews;

    private int reviewCount;
}
