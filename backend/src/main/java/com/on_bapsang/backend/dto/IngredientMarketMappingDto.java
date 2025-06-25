package com.on_bapsang.backend.dto;

import com.on_bapsang.backend.i18n.Translatable;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class IngredientMarketMappingDto {

    private Long ingredient_id;
    private Integer market_item_id;

    @Translatable
    private String ingredient_name;
}
