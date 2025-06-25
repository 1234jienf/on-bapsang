package com.on_bapsang.backend.dto;

import com.on_bapsang.backend.i18n.Translatable;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DishDto {
    @JsonProperty("recipe_id")
    private String recipeId;

    @Translatable
    private String name;

    @Translatable
    private List<String> ingredients;

    @Translatable
    private String descriptions;

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

    private double score;
    private boolean isScrapped;

    public void setIsScrapped(boolean scrapped) {
        this.isScrapped = scrapped;
    }
}
