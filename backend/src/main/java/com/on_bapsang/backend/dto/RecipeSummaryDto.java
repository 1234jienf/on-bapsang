package com.on_bapsang.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class RecipeSummaryDto {
    @JsonProperty("recipe_id")
    private String recipeId;

    private String name;

    /** 재료 이름만 간단히 */
    private List<String> ingredients;

    private String description;
    private String review;
    private String time;
    private String difficulty;
    private String portion;
    private String method;

    @JsonProperty("material_type")
    private String materialType;

    @JsonProperty("image_url")
    private String imageUrl;
    private boolean isScrapped;
}
