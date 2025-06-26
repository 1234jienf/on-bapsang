package com.on_bapsang.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SafeRestaurantRow {
    private Long   seq;            // RELAX_SEQ
    private String zipcode;        // RELAX_ZIPCODE
    private String siNm;           // RELAX_SI_NM
    private String sigunguNm;      // RELAX_SIDO_NM
    private String name;           // RELAX_RSTRNT_NM
    private String represent;      // RELAX_RSTRNT_REPRESENT
    private String regDate;        // RELAX_RSTRNT_REG_DT
    private String addr1;          // RELAX_ADD1
    private String addr2;          // RELAX_ADD2
    private String gubun;          // RELAX_GUBUN
    private String gubunDetail;    // RELAX_GUBUN_DETAIL
    private String tel;            // RELAX_RSTRNT_TEL
    private String etc;            // RELAX_RSTRNT_ETC
    private String useYn;          // RELAX_USE_YN
    private String cancelDate;     // RELAX_RSTRNT_CNCL_DT
    private String updateDate;     // UPDT_DT
}
