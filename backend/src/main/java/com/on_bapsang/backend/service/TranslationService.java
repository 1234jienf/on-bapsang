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
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

@Slf4j
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

    public String translate(String text, String targetLang) {
        if (text == null || text.trim().isEmpty()) {
            return text;
        }

        // 안정적인 캐시 키 생성
        String cacheKey = generateStableCacheKey(text, targetLang);

        try {
            // 캐시에서 먼저 확인
            String cachedTranslation = redisTemplate.opsForValue().get(cacheKey);
            if (cachedTranslation != null) {
                log.debug("Cache HIT for key: {}", cacheKey);
                return cachedTranslation;
            }

            log.debug("Cache MISS for key: {}, calling DeepL API", cacheKey);

            // 캐시에 없으면 DeepL API 호출
            String translated = callDeepLApi(text, targetLang);

            // 결과를 캐시에 저장 (24시간)
            redisTemplate.opsForValue().set(cacheKey, translated, CACHE_TTL, TimeUnit.HOURS);
            log.debug("Cached translation: {} -> {}", text, translated);

            return translated;
        } catch (Exception e) {
            log.error("Translation error for text: '{}', target: {}", text, targetLang, e);
            return text; // 실패 시 원문 반환
        }
    }

    // 배치 번역 - 여러 텍스트를 한번에 번역
    public Map<String, String> translateBatch(List<String> texts, String targetLang) {
        Map<String, String> results = new HashMap<>();
        List<String> uncachedTexts = new ArrayList<>();

        log.info("Starting batch translation for {} texts to {}", texts.size(), targetLang);

        // 캐시에서 먼저 확인
        for (String text : texts) {
            if (text == null || text.trim().isEmpty()) {
                results.put(text, text);
                continue;
            }

            String cacheKey = generateStableCacheKey(text, targetLang);
            try {
                String cachedTranslation = redisTemplate.opsForValue().get(cacheKey);
                if (cachedTranslation != null) {
                    results.put(text, cachedTranslation);
                    log.debug("Batch cache HIT: {}", text);
                } else {
                    uncachedTexts.add(text);
                    log.debug("Batch cache MISS: {}", text);
                }
            } catch (Exception e) {
                log.error("Redis error for text: '{}', adding to uncached list", text, e);
                uncachedTexts.add(text);
            }
        }

        // 캐시에 없는 텍스트들을 배치로 번역
        if (!uncachedTexts.isEmpty()) {
            log.info("Translating {} uncached texts via DeepL API", uncachedTexts.size());
            Map<String, String> batchResults = callDeepLApiBatch(uncachedTexts, targetLang);

            // 배치 결과를 캐시에 저장하고 결과에 추가
            for (Map.Entry<String, String> entry : batchResults.entrySet()) {
                String originalText = entry.getKey();
                String translatedText = entry.getValue();

                String cacheKey = generateStableCacheKey(originalText, targetLang);
                try {
                    redisTemplate.opsForValue().set(cacheKey, translatedText, CACHE_TTL, TimeUnit.HOURS);
                    log.debug("Batch cached: {} -> {}", originalText, translatedText);
                } catch (Exception e) {
                    log.error("Failed to cache translation for: '{}'", originalText, e);
                }

                results.put(originalText, translatedText);
            }
        }

        log.info("Batch translation completed: {}/{} texts processed", results.size(), texts.size());
        return results;
    }

    private String generateStableCacheKey(String text, String targetLang) {
        try {
            // MD5 해시를 사용하여 안정적인 키 생성 (JVM 재시작에도 동일한 키)
            MessageDigest md = MessageDigest.getInstance("MD5");
            String keyString = targetLang + ":" + text;
            byte[] hashBytes = md.digest(keyString.getBytes(StandardCharsets.UTF_8));

            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }

            return "translation:" + targetLang + ":" + sb.toString();
        } catch (Exception e) {
            // MD5 실패 시 기본 해시코드 사용 (fallback)
            log.warn("MD5 hash generation failed, using hashCode fallback", e);
            return "translation:" + targetLang + ":" + Math.abs(text.hashCode());
        }
    }

    private String callDeepLApi(String text, String targetLang) {
        String apiKey = getDeepLApiKey();
        if (apiKey == null || apiKey.trim().isEmpty()) {
            log.error("DeepL API key is not configured!");
            return text;
        }

        try {
            log.debug("Calling DeepL API for: '{}' -> {}", text, targetLang);

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
                        log.debug("DeepL API success: '{}' -> '{}'", text, result);
                        return result;
                    }
                }
            }

            log.warn("DeepL API returned unexpected response format: {}", response);
            return text; // 실패 시 원문 반환

        } catch (Exception e) {
            log.error("DeepL API call failed for text: '{}'", text, e);
            return text; // 실패 시 원문 반환
        }
    }

    private Map<String, String> callDeepLApiBatch(List<String> texts, String targetLang) {
        Map<String, String> results = new HashMap<>();
        String apiKey = getDeepLApiKey();

        if (apiKey == null || apiKey.trim().isEmpty()) {
            log.error("DeepL API key is not configured for batch translation!");
            // 실패 시 모든 텍스트를 원문으로 반환
            for (String text : texts) {
                results.put(text, text);
            }
            return results;
        }

        try {
            log.info("Calling DeepL API for batch translation: {} texts -> {}", texts.size(), targetLang);

            // DeepL API 배치 호출
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "DeepL-Auth-Key " + apiKey);

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
                            log.debug("Batch success: '{}' -> '{}'", texts.get(i), translatedText);
                        }
                    }
                }
            } else {
                log.warn("DeepL API batch returned unexpected response: {}", response);
            }

            // 번역되지 않은 텍스트는 원문으로 설정
            for (String text : texts) {
                if (!results.containsKey(text)) {
                    results.put(text, text);
                    log.debug("Using original text for untranslated: '{}'", text);
                }
            }

            log.info("Batch API call completed: {}/{} translations successful", results.size(), texts.size());

        } catch (Exception e) {
            log.error("Batch translation API call failed", e);
            // 실패 시 모든 텍스트를 원문으로 반환
            for (String text : texts) {
                results.put(text, text);
            }
        }

        return results;
    }

    private String getDeepLApiKey() {
        return System.getenv("DEEPL_API_KEY");
    }
}
