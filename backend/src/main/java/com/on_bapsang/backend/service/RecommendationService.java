
package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.DishDto;
import com.on_bapsang.backend.dto.RecommendRequest;
import com.on_bapsang.backend.dto.RecommendResponse;
import com.on_bapsang.backend.exception.CustomException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import java.util.List;

@Service
public class RecommendationService {
    private final WebClient aiWebClient;

    public RecommendationService(WebClient aiWebClient) {
        this.aiWebClient = aiWebClient;
    }

    public RecommendResponse getRecommendations(RecommendRequest req, int page, int size) {

        RecommendResponse raw = aiWebClient.post()
                .uri(uriBuilder -> uriBuilder
                        .path("/recommend")
                        .queryParam("top_k", 100)
                        .build())
                .bodyValue(req)
                .retrieve()
                .bodyToMono(RecommendResponse.class)
                .block();

        if (raw == null || raw.getRecommendedDishes() == null)
            throw new IllegalStateException("AI 서버 응답 오류");

        // ★ 추가 : 결과가 0개면 meta 정보만 설정하고 반환
        if (raw.getRecommendedDishes().isEmpty()) {
            // meta 정보 설정 (빈 결과)
            RecommendResponse.Meta meta = new RecommendResponse.Meta(page, false);
            raw.setMeta(meta);
            return raw; // 200 OK, recommended_dishes = [], meta 포함
        }

        // --- 원래 슬라이싱 로직 ---
        int totalSize = raw.getRecommendedDishes().size();
        int from = page * size;
        int to = Math.min(from + size, totalSize);

        if (from >= totalSize)
            throw new CustomException("요청 페이지 범위를 초과했습니다.", HttpStatus.BAD_REQUEST);

        // 페이징 처리
        raw.setRecommendedDishes(raw.getRecommendedDishes().subList(from, to));

        // meta 정보 설정
        boolean hasMore = to < totalSize; // 다음 페이지가 있는지 확인
        RecommendResponse.Meta meta = new RecommendResponse.Meta(page, hasMore);
        raw.setMeta(meta);

        return raw;
    }
}