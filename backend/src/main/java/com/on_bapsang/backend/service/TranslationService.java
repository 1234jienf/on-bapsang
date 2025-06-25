package com.on_bapsang.backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import java.util.concurrent.TimeUnit;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;

@Service
@RequiredArgsConstructor
public class TranslationService {

    private final ObjectMapper objectMapper;
    private final RedisTemplate<String, String> redisTemplate;
    private final RestTemplate restTemplate;

    private final WebClient webClient = WebClient.builder()
            .baseUrl("https://api-free.deepl.com/v2")
            .build();

    @Value("${deepl.api.key}")
    private String deeplApiKey;

    // 캐시 TTL: 24시간
    private static final long CACHE_TTL = 24;

    public String translate(String text, String targetLang) {
        if (text == null || text.trim().isEmpty()) {
            return text;
        }

        // 캐시 키 생성
        String cacheKey = "translation:" + targetLang + ":" + text.hashCode();

        // 캐시에서 먼저 확인
        String cachedTranslation = redisTemplate.opsForValue().get(cacheKey);
        if (cachedTranslation != null) {
            return cachedTranslation;
        }

        // 캐시에 없으면 DeepL API 호출
        String translated = callDeepLApi(text, targetLang);

        // 결과를 캐시에 저장 (24시간)
        redisTemplate.opsForValue().set(cacheKey, translated, CACHE_TTL, TimeUnit.HOURS);

        return translated;
    }

    // 배치 번역 - 여러 텍스트를 한번에 번역
    public Map<String, String> translateBatch(List<String> texts, String targetLang) {
        Map<String, String> results = new HashMap<>();
        List<String> uncachedTexts = new ArrayList<>();

        // 캐시에서 먼저 확인
        for (String text : texts) {
            if (text == null || text.trim().isEmpty()) {
                results.put(text, text);
                continue;
            }

            String cacheKey = "translation:" + targetLang + ":" + text.hashCode();
            String cachedTranslation = redisTemplate.opsForValue().get(cacheKey);

            if (cachedTranslation != null) {
                results.put(text, cachedTranslation);
            } else {
                uncachedTexts.add(text);
            }
        }

        // 캐시에 없는 텍스트들을 배치로 번역
        if (!uncachedTexts.isEmpty()) {
            Map<String, String> batchResults = callDeepLApiBatch(uncachedTexts, targetLang);

            // 배치 결과를 캐시에 저장하고 결과에 추가
            for (Map.Entry<String, String> entry : batchResults.entrySet()) {
                String originalText = entry.getKey();
                String translatedText = entry.getValue();

                String cacheKey = "translation:" + targetLang + ":" + originalText.hashCode();
                redisTemplate.opsForValue().set(cacheKey, translatedText, CACHE_TTL, TimeUnit.HOURS);

                results.put(originalText, translatedText);
            }
        }

        return results;
    }

    private String callDeepLApi(String text, String targetLang) {
        try {
            // DeepL API 호출 로직
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "DeepL-Auth-Key " + getDeepLApiKey());

            Map<String, Object> body = new HashMap<>();
            body.put("text", new String[] { text });
            body.put("target_lang", targetLang.toUpperCase());

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

            // API 호출
            Map<String, Object> response = restTemplate.postForObject(
                    "https://api-free.deepl.com/v2/translate",
                    request,
                    Map.class);

            if (response != null && response.containsKey("translations")) {
                Object translations = response.get("translations");
                if (translations instanceof java.util.List) {
                    java.util.List<?> translationList = (java.util.List<?>) translations;
                    if (!translationList.isEmpty() && translationList.get(0) instanceof Map) {
                        Map<?, ?> firstTranslation = (Map<?, ?>) translationList.get(0);
                        return (String) firstTranslation.get("text");
                    }
                }
            }

            return text; // 실패 시 원문 반환

        } catch (Exception e) {
            System.err.println("번역 API 호출 실패: " + e.getMessage());
            return text; // 실패 시 원문 반환
        }
    }

    private Map<String, String> callDeepLApiBatch(List<String> texts, String targetLang) {
        Map<String, String> results = new HashMap<>();

        try {
            // DeepL API 배치 호출
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "DeepL-Auth-Key " + getDeepLApiKey());

            Map<String, Object> body = new HashMap<>();
            body.put("text", texts.toArray(new String[0]));
            body.put("target_lang", targetLang.toUpperCase());

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

            // API 호출
            Map<String, Object> response = restTemplate.postForObject(
                    "https://api-free.deepl.com/v2/translate",
                    request,
                    Map.class);

            if (response != null && response.containsKey("translations")) {
                Object translations = response.get("translations");
                if (translations instanceof java.util.List) {
                    java.util.List<?> translationList = (java.util.List<?>) translations;

                    // 원본 텍스트와 번역 결과를 매핑
                    for (int i = 0; i < texts.size() && i < translationList.size(); i++) {
                        if (translationList.get(i) instanceof Map) {
                            Map<?, ?> translation = (Map<?, ?>) translationList.get(i);
                            String translatedText = (String) translation.get("text");
                            results.put(texts.get(i), translatedText);
                        }
                    }
                }
            }

            // 번역되지 않은 텍스트는 원문으로 설정
            for (String text : texts) {
                if (!results.containsKey(text)) {
                    results.put(text, text);
                }
            }

        } catch (Exception e) {
            System.err.println("배치 번역 API 호출 실패: " + e.getMessage());
            // 실패 시 모든 텍스트를 원문으로 반환
            for (String text : texts) {
                results.put(text, text);
            }
        }

        return results;
    }

    private String getDeepLApiKey() {
        // 환경변수나 설정에서 API 키 가져오기
        return System.getenv("DEEPL_API_KEY");
    }
}
