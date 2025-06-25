package com.on_bapsang.backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

@Service
@RequiredArgsConstructor
public class TranslationService {

    private final ObjectMapper objectMapper;

    private final WebClient webClient = WebClient.builder()
            .baseUrl("https://api-free.deepl.com/v2")
            .build();

    @Value("${deepl.api.key}")
    private String deeplApiKey;

    public String translate(String text, String targetLang) {
        if (text == null || text.trim().isEmpty()) return text;

        String response = webClient.post()
                .uri("/translate")
                .header("Content-Type", "application/x-www-form-urlencoded")
                .bodyValue("auth_key=" + deeplApiKey +
                        "&text=" + text +
                        "&target_lang=" + targetLang)
                .retrieve()
                .bodyToMono(String.class)
                .block();

        try {
            JsonNode root = objectMapper.readTree(response);
            return root.get("translations").get(0).get("text").asText();
        } catch (Exception e) {
            throw new RuntimeException("DeepL 응답 파싱 중 오류 발생", e);
        }
    }
}
