package com.on_bapsang.backend.dto;

import com.on_bapsang.backend.i18n.Translatable;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
public class MarketTimeseriesResponse {

    @Translatable
    private String ingredient;

    @Translatable
    private String market;

    @Translatable
    private String unit;

    @Translatable
    private String origin;

    private List<MonthlyPriceDto> monthlyPrices;

    @Getter
    @Setter
    @Builder
    public static class MonthlyPriceDto {
        private String date;
        private Integer price;
    }
}
