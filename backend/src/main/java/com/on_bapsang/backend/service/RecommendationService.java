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

        // ★ 추가 : 결과가 0개면 그대로 돌려주고 끝
        if (raw.getRecommendedDishes().isEmpty()) {
            return raw; // 200 OK, recommended_dishes = []
        }

        // --- 원래 슬라이싱 로직 ---
        int from = page * size;
        int to = Math.min(from + size, raw.getRecommendedDishes().size());

        if (from >= raw.getRecommendedDishes().size())
            throw new CustomException("요청 페이지 범위를 초과했습니다.", HttpStatus.BAD_REQUEST);

        raw.setRecommendedDishes(raw.getRecommendedDishes().subList(from, to));
        return raw;
    }

}