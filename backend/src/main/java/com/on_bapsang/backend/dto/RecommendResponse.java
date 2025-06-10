package com.on_bapsang.backend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import java.util.List;

@Data
public class RecommendResponse {

    @Getter
    @AllArgsConstructor
    public static class Meta {
        private int currentPage; // 현재 페이지 번호
        private boolean hasMore; // 다음 페이지 여부
    }

    /** 요청에 넣은 food_name이 그대로 echo 됩니다 */
    @JsonProperty("food_name")
    private String foodName;

    /** 고정된 메시지 */
    private String message;

    /** AI가 추천한 레시피 리스트 */
    @JsonProperty("recommended_dishes")
    private List<DishDto> recommendedDishes;

    /** 페이징 메타 정보 */
    private Meta meta;
}