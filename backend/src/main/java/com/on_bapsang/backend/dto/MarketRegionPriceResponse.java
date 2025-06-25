package com.on_bapsang.backend.dto;

import com.on_bapsang.backend.i18n.Translatable;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
public class MarketRegionPriceResponse {

    private Long ingredientId;

    @Translatable
    private String ingredientName;

    @Translatable
    private String unit;

    private String yearMonth;
    private List<MarketRegionDto> markets;

    @Getter
    @Setter
    @Builder
    public static class MarketRegionDto {

        @Translatable
        private String market;

        private Integer averagePrice;
    }
}

