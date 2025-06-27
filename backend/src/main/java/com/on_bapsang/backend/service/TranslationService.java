package com.on_bapsang.backend.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

@Service
@RequiredArgsConstructor
public class TranslationService {

    private final ObjectMapper objectMapper;
    private final RedisTemplate<String, String> redisTemplate;
    private final RestTemplate restTemplate;

    private final WebClient webClient = WebClient.builder()
            .baseUrl("https://api-free.deepl.com/v2")
            .build();

    // 캐시 TTL: 24시간
    private static final long CACHE_TTL = 24;

    @Value("${deepl.api.key:}")
    private String deeplApiKey;

    public String translate(String text, String targetLang) {
        if (text == null || text.trim().isEmpty()) {
            // Empty text provided for translation
            return text;
        }

        try {
            // 안정적인 캐시 키 생성 (SHA-256 해시 사용)
            String cacheKey = "translation:" + targetLang + ":" + generateStableHash(text);

            // 캐시에서 먼저 확인
            String cachedTranslation = redisTemplate.opsForValue().get(cacheKey);
            if (cachedTranslation != null) {
                return cachedTranslation;
            }

            // 캐시에 없으면 DeepL API 호출 (최대 3회 재시도)
            String translated = callDeepLApiWithRetry(text, targetLang, 3);

            // 결과를 캐시에 저장 (24시간)
            if (translated != null && !translated.equals(text)) {
                redisTemplate.opsForValue().set(cacheKey, translated, CACHE_TTL, TimeUnit.HOURS);
            }

            return translated;

        } catch (Exception e) {
            return text; // 실패 시 원문 반환
        }
    }

    // 배치 번역 - 여러 텍스트를 한번에 번역
    public Map<String, String> translateBatch(List<String> texts, String targetLang) {
        Map<String, String> results = new HashMap<>();
        List<String> uncachedTexts = new ArrayList<>();

        // Starting batch translation

        // 캐시에서 먼저 확인
        for (String text : texts) {
            if (text == null || text.trim().isEmpty()) {
                results.put(text, text);
                continue;
            }

            String cacheKey = "translation:" + targetLang + ":" + generateStableHash(text);
            String cachedTranslation = redisTemplate.opsForValue().get(cacheKey);

            if (cachedTranslation != null) {
                results.put(text, cachedTranslation);
                // Cache HIT for batch item
            } else {
                uncachedTexts.add(text);
                // Cache MISS for batch item
            }
        }

        // Found cached translations, need API calls

        // 캐시에 없는 텍스트들을 배치로 번역
        if (!uncachedTexts.isEmpty()) {
            Map<String, String> batchResults = callDeepLApiBatch(uncachedTexts, targetLang);

            // 배치 결과를 캐시에 저장하고 결과에 추가
            for (Map.Entry<String, String> entry : batchResults.entrySet()) {
                String originalText = entry.getKey();
                String translatedText = entry.getValue();

                String cacheKey = "translation:" + targetLang + ":" + generateStableHash(originalText);
                redisTemplate.opsForValue().set(cacheKey, translatedText, CACHE_TTL, TimeUnit.HOURS);

                results.put(originalText, translatedText);
            }
        }

        // Batch translation completed
        return results;
    }

    private String callDeepLApiWithRetry(String text, String targetLang, int maxRetries) {
        for (int attempt = 1; attempt <= maxRetries; attempt++) {
            try {
                String result = callDeepLApi(text, targetLang);
                if (result != null && !result.equals(text)) {
                    return result; // 번역 성공
                }
                if (attempt < maxRetries) {
                    Thread.sleep(1000 * attempt); // 재시도 간격 증가
                }
            } catch (Exception e) {
                if (attempt == maxRetries) {
                    return text; // 최종 실패 시 원문 반환
                }
                try {
                    Thread.sleep(1000 * attempt);
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                    return text;
                }
            }
        }
        return text;
    }

    private String callDeepLApi(String text, String targetLang) {
        try {
            // API 키 검증
            String apiKey = getDeepLApiKey();
            if (apiKey == null || apiKey.trim().isEmpty()) {
                return text;
            }

            // DeepL API 호출 로직
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "DeepL-Auth-Key " + apiKey);

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
                        String result = (String) firstTranslation.get("text");
                        return result != null ? result : text;
                    }
                }
            }

            return text; // 실패 시 원문 반환

        } catch (Exception e) {
            return text; // 실패 시 원문 반환
        }
    }

    private Map<String, String> callDeepLApiBatch(List<String> texts, String targetLang) {
        Map<String, String> results = new HashMap<>();

        try {
            // Calling DeepL batch API

            // API 키 검증
            String apiKey = getDeepLApiKey();
            if (apiKey == null || apiKey.trim().isEmpty()) {
                // DeepL API key is not configured for batch translation
                // 실패 시 모든 텍스트를 원문으로 반환
                for (String text : texts) {
                    results.put(text, text);
                }
                return results;
            }

            // DeepL API 배치 호출
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "DeepL-Auth-Key " + apiKey);

            Map<String, Object> body = new HashMap<>();
            body.put("text", texts.toArray(new String[0]));
            body.put("target_lang", targetLang.toUpperCase());

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

            long startTime = System.currentTimeMillis();

            // API 호출
            Map<String, Object> response = restTemplate.postForObject(
                    "https://api-free.deepl.com/v2/translate",
                    request,
                    Map.class);

            long duration = System.currentTimeMillis() - startTime;
            // DeepL batch API call completed

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

                    // Batch translation successful
                }
            }

            // 번역되지 않은 텍스트는 원문으로 설정
            for (String text : texts) {
                if (!results.containsKey(text)) {
                    results.put(text, text);
                    // Text not translated, using original
                }
            }

        } catch (Exception e) {
            // Batch translation API call failed
            // 실패 시 모든 텍스트를 원문으로 반환
            for (String text : texts) {
                results.put(text, text);
            }
        }

        return results;
    }

    private String getDeepLApiKey() {
        // @Value에서 먼저 시도, 없으면 환경변수에서
        String apiKey = this.deeplApiKey;
        if (apiKey == null || apiKey.trim().isEmpty()) {
            apiKey = System.getenv("DEEPL_API_KEY");
        }

        if (apiKey != null && !apiKey.trim().isEmpty()) {
            // DeepL API key found
            return apiKey;
        }

        // DeepL API key not found in @Value or environment variables
        return null;
    }

    /**
     * 안정적인 해시 생성 (SHA-256 사용)
     */
    private String generateStableHash(String text) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(text.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.substring(0, 32); // 32자리로 제한
        } catch (Exception e) {
            // MD5로 대체 시도
            try {
                MessageDigest md5 = MessageDigest.getInstance("MD5");
                byte[] hash = md5.digest(text.getBytes(StandardCharsets.UTF_8));
                StringBuilder hexString = new StringBuilder();
                for (byte b : hash) {
                    String hex = Integer.toHexString(0xff & b);
                    if (hex.length() == 1) {
                        hexString.append('0');
                    }
                    hexString.append(hex);
                }
                return hexString.toString();
            } catch (Exception e2) {
                // 마지막 대안으로 hashCode 사용
                return String.valueOf(Math.abs(text.hashCode()));
            }
        }
    }
}