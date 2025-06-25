package com.on_bapsang.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.on_bapsang.backend.i18n.Translatable;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class IngredientDetailDto {

    @JsonProperty("ingredient_id")
    private String ingredientId;

    @Translatable
    private String name;

    @Translatable
    private String amount;
}

