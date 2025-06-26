package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.SafeRestaurantResponse;
import com.on_bapsang.backend.dto.SafeRestaurantRow;
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

@Service
public class SafeRestaurantDomService {

    private static final String BASE = "http://211.237.50.150:7080/openapi";
    private static final String KEY = "3e96712d2228de13b051ada843f8ae197cc678083e6a0f886b915b9e55e80d0d";

    private final WebClient client = WebClient.builder()
            .baseUrl(BASE)
            .build();

    /**
     * @param city  시/도명 (RELAX_SI_NM)
     * @param gu    시군구명 (RELAX_SIDO_NM)
     * @param start START_INDEX
     * @param end   END_INDEX (최대 1000)
     */
    public SafeRestaurantResponse fetch(String city, String gu,
            int start, int end) throws Exception {

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
            list.add(map(e));
        }

        return new SafeRestaurantResponse(totalCount, list);
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
                get(e, "UPDT_DT"));
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
