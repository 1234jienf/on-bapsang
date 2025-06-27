package com.on_bapsang.backend.dto.seasonal;

import com.on_bapsang.backend.i18n.Translatable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Getter
public class SeasonalFoodDto {

    private Long idntfcNo;
    private String prdlstNm;

    @Translatable
    private String prdlstNmTranslated;

    private String mDistctns;

    @Translatable
    private String effect;

    @Translatable
    private String purchaseMth;

    @Translatable
    private String cookMth;

    private String imgUrl;
}
