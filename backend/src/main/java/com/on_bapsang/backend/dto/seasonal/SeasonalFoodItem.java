package com.on_bapsang.backend.dto.seasonal;

import com.on_bapsang.backend.i18n.Translatable;
import jakarta.xml.bind.annotation.XmlAccessType;
import jakarta.xml.bind.annotation.XmlAccessorType;
import jakarta.xml.bind.annotation.XmlRootElement;
import lombok.Data;


@Data
@XmlRootElement(name = "row")
@XmlAccessorType(XmlAccessType.FIELD)
public class SeasonalFoodItem {

    private String IDNTFC_NO;

    @Translatable
    private String PRDLST_NM;

    @Translatable
    private String M_DISTCTNS;

    @Translatable
    private String M_DISTCTNS_ITM;

    @Translatable
    private String PRDLST_CL;

    @Translatable
    private String MTC_NM;

    @Translatable
    private String PRDCTN__ERA;

    @Translatable
    private String MAIN_SPCIES_NM;

    @Translatable
    private String EFFECT;

    @Translatable
    private String PURCHASE_MTH;

    @Translatable
    private String COOK_MTH;

    @Translatable
    private String TRT_MTH;

    private String URL;
    private String IMG_URL;
    private String REGIST_DE;
}
