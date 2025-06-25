package com.on_bapsang.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.on_bapsang.backend.i18n.Translatable;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class RecipeSummaryDto {

    @JsonProperty("recipe_id")
    private String recipeId;

    @Translatable
    private String name;

    @Translatable
    private List<String> ingredients;

    @Translatable
    private String description;

    @Translatable
    private String review;

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

    @JsonProperty("image_url")
    private String imageUrl;

    private boolean isScrapped;
}
