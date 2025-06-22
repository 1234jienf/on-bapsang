package com.on_bapsang.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

@Getter
@AllArgsConstructor
public class PopularRecipeDto {

    @JsonProperty("recipe_id")
    private String recipeId;

    private String name;
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

    private int postCount; // 후기 수
}
