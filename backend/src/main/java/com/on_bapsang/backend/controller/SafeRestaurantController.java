package com.on_bapsang.backend.controller;

import com.on_bapsang.backend.dto.SafeRestaurantResponse;
import com.on_bapsang.backend.service.SafeRestaurantDomService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/safe-restaurants")
public class SafeRestaurantController {

    private final SafeRestaurantDomService service;

    /**
     * 안전음식점 목록 조회
     * 
     * @param city               시/도명 (예: 경상북도)
     * @param gu                 시군구명 (예: 포항시)
     * @param start              시작 인덱스 (기본값: 1)
     * @param end                종료 인덱스 (기본값: 100, 최대: 1000)
     * @param includeCoordinates 위도/경도 포함 여부 (기본값: false)
     * @return 안전음식점 응답
     */
    @GetMapping
    public SafeRestaurantResponse list(
            @RequestParam String city,
            @RequestParam String gu,
            @RequestParam(defaultValue = "1") int start,
            @RequestParam(defaultValue = "100") int end,
            @RequestParam(defaultValue = "false") boolean includeCoordinates) throws Exception {

        log.info("Fetching safe restaurants: city={}, gu={}, start={}, end={}, includeCoordinates={}",
                city, gu, start, end, includeCoordinates);

        if (includeCoordinates) {
            log.warn("Geocoding enabled - this may take longer due to external API calls");
        }

        SafeRestaurantResponse response = service.fetch(city, gu, start, end, includeCoordinates);

        log.info("Fetched {} restaurants, total count: {}",
                response.getRows() != null ? response.getRows().size() : 0,
                response.getTotalCnt());

        return response;
    }
}
