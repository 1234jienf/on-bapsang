package com.on_bapsang.backend.service;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.List;

@Slf4j
@Service
public class GeocodingService {

  @Value("${kakao.api.key:}")
  private String kakaoApiKey;

  private final WebClient kakaoClient = WebClient.builder()
      .baseUrl("https://dapi.kakao.com")
      .build();

  /**
   * 주소를 위도/경도로 변환
   */
  public Coordinates getCoordinates(String address) {
    if (kakaoApiKey == null || kakaoApiKey.trim().isEmpty()) {
      log.warn("Kakao API key not configured, skipping geocoding for: {}", address);
      return null;
    }

    try {
      log.debug("Geocoding address: {}", address);

      KakaoGeocodingResponse response = kakaoClient.get()
          .uri("/v2/local/search/address.json?query={address}", address)
          .header("Authorization", "KakaoAK " + kakaoApiKey)
          .retrieve()
          .bodyToMono(KakaoGeocodingResponse.class)
          .onErrorResume(ex -> {
            log.error("Kakao geocoding failed for address: {}, error: {}", address, ex.getMessage());
            return Mono.empty();
          })
          .block();

      if (response != null && response.getDocuments() != null && !response.getDocuments().isEmpty()) {
        KakaoDocument doc = response.getDocuments().get(0);
        double lat = Double.parseDouble(doc.getY());
        double lng = Double.parseDouble(doc.getX());

        log.debug("Geocoding success: {} -> lat={}, lng={}", address, lat, lng);
        return new Coordinates(lat, lng);
      } else {
        log.warn("No coordinates found for address: {}", address);
        return null;
      }
    } catch (Exception e) {
      log.error("Geocoding error for address: {}", address, e);
      return null;
    }
  }

  @Data
  public static class Coordinates {
    private final double latitude;
    private final double longitude;
  }

  @Data
  private static class KakaoGeocodingResponse {
    private List<KakaoDocument> documents;
  }

  @Data
  private static class KakaoDocument {
    private String x; // 경도
    private String y; // 위도

    @JsonProperty("address_name")
    private String addressName;

    @JsonProperty("address_type")
    private String addressType;
  }
}