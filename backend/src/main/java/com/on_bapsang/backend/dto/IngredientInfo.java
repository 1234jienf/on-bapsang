package com.on_bapsang.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class IngredientInfo {
    @JsonProperty("ingredient_id")
    private Long ingredientId;

    @JsonProperty("ingredient")
    private String ingredientName;

    @JsonProperty("material_type")
    private String category;

    @JsonProperty("image_url")
    private String imageUrl;

    @JsonProperty("sale_price")
    private int salePrice;

    @JsonProperty("original_price")
    private int originalPrice;

    @JsonProperty("discount_rate")
    private String discountRate;
}
