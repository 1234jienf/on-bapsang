package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.SafeRestaurantResponse;
import com.on_bapsang.backend.dto.SafeRestaurantRow;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class SafeRestaurantDomService {

    private static final String BASE = "http://211.237.50.150:7080/openapi";
    private static final String KEY = "3e96712d2228de13b051ada843f8ae197cc678083e6a0f886b915b9e55e80d0d";

    private final GeocodingService geocodingService;

    private final WebClient client = WebClient.builder()
            .baseUrl(BASE)
            .build();

    /**
     * @param city               시/도명 (RELAX_SI_NM)
     * @param gu                 시군구명 (RELAX_SIDO_NM)
     * @param start              START_INDEX
     * @param end                END_INDEX (최대 1000)
     * @param includeCoordinates 위도/경도 포함 여부
     */
    public SafeRestaurantResponse fetch(String city, String gu,
            int start, int end, boolean includeCoordinates) throws Exception {

        /* 1) XML 문자열 수신 */
        String path = "/%s/xml/Grid_20200713000000000605_1/%d/%d"
                .formatted(KEY, start, end);

        String xml = client.get()
                .uri(u -> u.path(path)
                        .queryParam("RELAX_SI_NM", city)
                        .queryParam("RELAX_SIDO_NM", gu)
                        .build())
                .retrieve()
                .bodyToMono(String.class)
                .block();

        /* 2) DOM 파서 준비 */
        DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
        DocumentBuilder b = f.newDocumentBuilder();
        Document doc = b.parse(new ByteArrayInputStream(xml.getBytes()));

        /* 3) totalCount 파싱 */
        Integer totalCount = null;
        NodeList totalCountNodes = doc.getElementsByTagName("totalCnt");
        if (totalCountNodes.getLength() > 0) {
            String totalCountText = totalCountNodes.item(0).getTextContent();
            totalCount = Integer.valueOf(totalCountText);
        }

        /* 4) row 태그 반복 파싱 */
        NodeList rows = doc.getElementsByTagName("row");
        List<SafeRestaurantRow> list = new ArrayList<>();

        for (int i = 0; i < rows.getLength(); i++) {
            Element e = (Element) rows.item(i);
            SafeRestaurantRow row = map(e);

            // 위도/경도 추가
            if (includeCoordinates) {
                addCoordinates(row);
            }

            list.add(row);
        }

        return new SafeRestaurantResponse(totalCount, list);
    }

    /**
     * 기존 호환성을 위한 오버로드 메서드
     */
    public SafeRestaurantResponse fetch(String city, String gu, int start, int end) throws Exception {
        return fetch(city, gu, start, end, false);
    }

    /**
     * 주소로 위도/경도를 찾아서 추가
     */
    private void addCoordinates(SafeRestaurantRow row) {
        try {
            String fullAddress = buildFullAddress(row);
            if (fullAddress != null && !fullAddress.trim().isEmpty()) {
                log.debug("Geocoding for: {} - {}", row.getName(), fullAddress);

                GeocodingService.Coordinates coords = geocodingService.getCoordinates(fullAddress);
                if (coords != null) {
                    row.setLatitude(coords.getLatitude());
                    row.setLongitude(coords.getLongitude());
                    log.debug("Added coordinates for {}: lat={}, lng={}",
                            row.getName(), coords.getLatitude(), coords.getLongitude());
                } else {
                    log.warn("No coordinates found for: {} - {}", row.getName(), fullAddress);
                }
            }
        } catch (Exception e) {
            log.error("Failed to geocode address for: {} - {}", row.getName(), row.getAddr1(), e);
        }
    }

    /**
     * 전체 주소 조합
     */
    private String buildFullAddress(SafeRestaurantRow row) {
        StringBuilder address = new StringBuilder();

        if (row.getAddr1() != null && !row.getAddr1().trim().isEmpty()) {
            address.append(row.getAddr1().trim());
        }

        if (row.getAddr2() != null && !row.getAddr2().trim().isEmpty()) {
            if (address.length() > 0) {
                address.append(" ");
            }
            address.append(row.getAddr2().trim());
        }

        return address.toString();
    }

    /* Element → DTO 매핑 */
    private SafeRestaurantRow map(Element e) {
        return new SafeRestaurantRow(
                getLong(e, "RELAX_SEQ"),
                get(e, "RELAX_ZIPCODE"),
                get(e, "RELAX_SI_NM"),
                get(e, "RELAX_SIDO_NM"),
                get(e, "RELAX_RSTRNT_NM"),
                get(e, "RELAX_RSTRNT_REPRESENT"),
                get(e, "RELAX_RSTRNT_REG_DT"),
                get(e, "RELAX_ADD1"),
                get(e, "RELAX_ADD2"),
                get(e, "RELAX_GUBUN"),
                get(e, "RELAX_GUBUN_DETAIL"),
                get(e, "RELAX_RSTRNT_TEL"),
                get(e, "RELAX_RSTRNT_ETC"),
                get(e, "RELAX_USE_YN"),
                get(e, "RELAX_RSTRNT_CNCL_DT"),
                get(e, "UPDT_DT"),
                null, // latitude - 나중에 지오코딩으로 설정
                null // longitude - 나중에 지오코딩으로 설정
        );
    }

    /* 편의 메서드 */
    private static String get(Element e, String tag) {
        Node n = e.getElementsByTagName(tag).item(0);
        return n == null ? null : n.getTextContent();
    }

    private static Long getLong(Element e, String tag) {
        String s = get(e, tag);
        return (s == null || s.isBlank()) ? null : Long.valueOf(s);
    }
}
