package com.on_bapsang.backend.config;

import com.on_bapsang.backend.i18n.Translatable;
import com.on_bapsang.backend.service.TranslationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

import java.lang.reflect.Field;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import com.fasterxml.jackson.databind.ObjectMapper;

@ControllerAdvice
@RequiredArgsConstructor
@Slf4j
public class TranslationResponseAdvice implements ResponseBodyAdvice<Object> {

    private final TranslationService translationService;

    @Override
    public boolean supports(MethodParameter returnType, Class converterType) {
        return returnType.getContainingClass().getPackageName().contains("controller");
    }

    @Override
    public Object beforeBodyWrite(Object body,
            MethodParameter returnType,
            MediaType selectedContentType,
            Class selectedConverterType,
            ServerHttpRequest request,
            ServerHttpResponse response) {

        String lang = request.getHeaders().getFirst("X-Language");
        if (lang == null || lang.equalsIgnoreCase("KO")) {
            return body;
        }

        String requestPath = request.getURI().getPath();
        String queryString = request.getURI().getQuery();
        String fullPath = requestPath + (queryString != null ? "?" + queryString : "");

        // 응답 레벨 캐싱 체크
        String responseCacheKey = "response_cache:" + lang + ":" + generateStableHash(fullPath);

        try {
            // 캐시된 응답이 있는지 확인 (빠른 반환)
            String cachedResponse = translationService.getCachedResponse(responseCacheKey);
            if (cachedResponse != null) {
                log.debug("Returning cached translated response for path: {}, language: {}", fullPath, lang);
                return deserializeResponse(cachedResponse, body.getClass());
            }
        } catch (Exception e) {
            log.debug("Cache lookup failed, proceeding with translation: {}", e.getMessage());
        }

        log.debug("Translation requested for path: {}, language: {}", fullPath, lang);

        try {
            if (!hasTranslatableFields(body)) {
                log.debug("No translatable fields found in response body");
                return body;
            }

            log.info("Starting translation process for language: {}", lang);
            long startTime = System.currentTimeMillis();

            CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
                try {
                    translateRecursively(body, lang);
                } catch (Exception e) {
                    log.error("Translation process failed: {}", e.getMessage(), e);
                }
            });

            // 타임아웃을 8초로 단축 (빠른 응답 우선)
            future.get(8, TimeUnit.SECONDS);

            long duration = System.currentTimeMillis() - startTime;
            log.info("Translation completed in {}ms for language: {}", duration, lang);

            // 번역된 응답을 캐시에 저장 (5분)
            try {
                String serializedResponse = serializeResponse(body);
                translationService.cacheResponse(responseCacheKey, serializedResponse, 5);
                log.debug("Cached translated response for path: {}, language: {}", fullPath, lang);
            } catch (Exception e) {
                log.warn("Failed to cache translated response: {}", e.getMessage());
            }

        } catch (Exception e) {
            log.error("Translation timeout or failure for path: {}, language: {}, error: {}",
                    fullPath, lang, e.getMessage());
            // 타임아웃이나 실패 시에도 원본 응답 반환 (부분 번역된 내용 포함)
        }

        return body;
    }

    private boolean hasTranslatableFields(Object obj) {
        return hasTranslatableFields(obj, Collections.newSetFromMap(new IdentityHashMap<>()));
    }

    private boolean hasTranslatableFields(Object obj, Set<Object> visited) {
        if (obj == null || visited.contains(obj))
            return false;
        visited.add(obj);

        if (obj instanceof Iterable<?> iterable) {
            for (Object element : iterable) {
                if (hasTranslatableFields(element, visited))
                    return true;
            }
        } else if (!isSkippable(obj)) {
            for (Field field : obj.getClass().getDeclaredFields()) {
                field.setAccessible(true);
                try {
                    if (field.isAnnotationPresent(Translatable.class))
                        return true;
                    Object fieldValue = field.get(obj);
                    if (hasTranslatableFields(fieldValue, visited))
                        return true;
                } catch (Exception ignored) {
                }
            }
        }

        return false;
    }

    private void translateRecursively(Object obj, String lang) throws IllegalAccessException {
        translateRecursively(obj, lang, Collections.newSetFromMap(new IdentityHashMap<>()));
    }

    private void translateRecursively(Object obj, String lang, Set<Object> visited) throws IllegalAccessException {
        if (obj == null || visited.contains(obj))
            return;
        visited.add(obj);

        if (obj instanceof Iterable<?> iterable) {
            for (Object element : iterable) {
                translateRecursively(element, lang, visited);
            }
            return;
        }

        if (isSkippable(obj))
            return;

        // 배치 번역을 위한 수집
        List<String> textsToTranslate = new ArrayList<>();
        List<FieldTextPair> fieldTextPairs = new ArrayList<>();

        Class<?> clazz = obj.getClass();
        for (Field field : clazz.getDeclaredFields()) {
            field.setAccessible(true);
            Object fieldValue;
            try {
                fieldValue = field.get(obj);
            } catch (Exception e) {
                log.warn("Failed to access field {}: {}", field.getName(), e.getMessage());
                continue;
            }

            if (fieldValue == null)
                continue;

            if (field.isAnnotationPresent(Translatable.class)) {
                if (fieldValue instanceof String original && !original.trim().isEmpty()) {
                    // 이미 번역된 텍스트인지 확인 (한국어가 아니면 건너뛰기)
                    if (needsTranslation(original, lang)) {
                        textsToTranslate.add(original);
                        fieldTextPairs.add(new FieldTextPair(field, obj, original, FieldType.STRING));
                    }
                } else if (fieldValue instanceof List<?> list && !list.isEmpty() && list.get(0) instanceof String) {
                    List<String> untranslatedItems = new ArrayList<>();
                    for (String item : (List<String>) list) {
                        if (item != null && !item.trim().isEmpty() && needsTranslation(item, lang)) {
                            textsToTranslate.add(item);
                            untranslatedItems.add(item);
                        }
                    }
                    // 번역이 필요한 항목이 있을 때만 추가
                    if (!untranslatedItems.isEmpty()) {
                        fieldTextPairs.add(new FieldTextPair(field, obj, list, FieldType.STRING_LIST));
                    }
                }
            } else if (fieldValue instanceof Iterable<?> nestedIterable) {
                for (Object element : nestedIterable) {
                    translateRecursively(element, lang, visited);
                }
            } else {
                translateRecursively(fieldValue, lang, visited);
            }
        }

        // 배치 번역 실행 + 개별 번역 백업
        if (!textsToTranslate.isEmpty()) {
            performComprehensiveTranslation(textsToTranslate, fieldTextPairs, lang);
        }
    }

    private void performComprehensiveTranslation(List<String> textsToTranslate, List<FieldTextPair> fieldTextPairs,
            String lang) {
        try {
            log.debug("Starting comprehensive translation for {} texts", textsToTranslate.size());

            // 1단계: 배치 번역 시도
            Map<String, String> batchResults = translationService.translateBatch(textsToTranslate, lang);

            // 2단계: 배치 번역 실패한 항목들 개별 번역
            List<String> failedTexts = new ArrayList<>();
            for (String text : textsToTranslate) {
                String translated = batchResults.get(text);
                if (translated == null || translated.equals(text)) {
                    failedTexts.add(text);
                }
            }

            // 실패한 텍스트가 많으면 개별 번역 건너뛰기 (속도 우선)
            if (!failedTexts.isEmpty() && failedTexts.size() <= 5) {
                log.info("Batch translation failed for {} texts, retrying individually", failedTexts.size());

                // 개별 번역으로 재시도 (최대 5개까지만)
                for (String failedText : failedTexts) {
                    try {
                        String individualResult = translationService.translate(failedText, lang);
                        if (!individualResult.equals(failedText)) {
                            batchResults.put(failedText, individualResult);
                            log.debug("Individual translation success: {} -> {}", failedText, individualResult);
                        }
                    } catch (Exception e) {
                        log.warn("Individual translation also failed for: {}", failedText);
                    }
                }
            } else if (failedTexts.size() > 5) {
                log.info("Too many failed texts ({}), skipping individual retry for speed", failedTexts.size());
            }

            // 3단계: 번역 결과를 필드에 적용
            AtomicInteger successCount = new AtomicInteger(0);
            AtomicInteger totalCount = new AtomicInteger(0);

            for (FieldTextPair pair : fieldTextPairs) {
                try {
                    if (pair.fieldType == FieldType.STRING) {
                        String originalText = (String) pair.originalValue;
                        String translatedText = batchResults.get(originalText);
                        totalCount.incrementAndGet();

                        if (translatedText != null && !translatedText.equals(originalText)) {
                            pair.field.set(pair.parentObject, translatedText);
                            successCount.incrementAndGet();
                        }
                    } else if (pair.fieldType == FieldType.STRING_LIST) {
                        List<String> originalList = (List<String>) pair.originalValue;
                        List<String> translatedList = originalList.stream()
                                .map(item -> {
                                    totalCount.incrementAndGet();
                                    String translated = batchResults.get(item);
                                    if (translated != null && !translated.equals(item)) {
                                        successCount.incrementAndGet();
                                        return translated;
                                    } else {
                                        return item;
                                    }
                                })
                                .toList();
                        pair.field.set(pair.parentObject, translatedList);
                    }
                } catch (Exception e) {
                    log.warn("Failed to set translated value for field {}: {}",
                            pair.field.getName(), e.getMessage());
                }
            }

            int successRate = totalCount.get() > 0 ? (successCount.get() * 100 / totalCount.get()) : 0;
            log.info("Translation completed: {}/{} successful ({}%)",
                    successCount.get(), totalCount.get(), successRate);

            // 성공률이 낮으면 경고
            if (successRate < 80) {
                log.warn("Low translation success rate: {}%. Consider checking DeepL API status.", successRate);
            }

        } catch (Exception e) {
            log.error("Comprehensive translation failed: {}", e.getMessage(), e);
        }
    }

    private boolean isSkippable(Object obj) {
        Class<?> clazz = obj.getClass();
        return clazz.isPrimitive()
                || clazz.equals(String.class)
                || Number.class.isAssignableFrom(clazz)
                || Boolean.class.isAssignableFrom(clazz)
                || Enum.class.isAssignableFrom(clazz)
                || clazz.getPackageName().startsWith("java.");
    }

    /**
     * 텍스트가 번역이 필요한지 확인
     * 이미 번역된 텍스트(일본어/영어 등)는 건너뛰고, 한국어만 번역
     */
    private boolean needsTranslation(String text, String targetLang) {
        if (text == null || text.trim().isEmpty()) {
            return false;
        }

        // 숫자나 특수문자만 있는 경우 번역 불필요
        if (text.matches("^[0-9\\s\\p{Punct}]+$")) {
            return false;
        }

        boolean result;
        // 목표 언어에 따른 번역 필요성 판단
        switch (targetLang.toUpperCase()) {
            case "JA":
                // 일본어가 목표인 경우: 이미 일본어(히라가나, 가타카나, 한자)면 건너뛰기
                result = !containsJapanese(text);
                break;
            case "EN":
                // 영어가 목표인 경우: 이미 영어면 건너뛰기
                result = !isEnglishText(text);
                break;
            case "ZH":
            case "ZH-CN":
            case "ZH-TW":
                // 중국어가 목표인 경우: 이미 중국어(간체/번체 한자)면 건너뛰기
                result = !containsChinese(text);
                break;
            default:
                // 기본적으로 한국어가 포함되어 있으면 번역 필요
                result = containsKorean(text);
                break;
        }

        // 디버그 로그 추가
        log.debug("needsTranslation('{}', {}) = {} [Korean: {}, Japanese: {}, Chinese: {}, English: {}]",
                text, targetLang, result,
                containsKorean(text), containsJapanese(text), containsChinese(text), isEnglishText(text));

        return result;
    }

    private boolean containsKorean(String text) {
        return text.chars().anyMatch(ch -> (ch >= 0xAC00 && ch <= 0xD7AF) || // 한글 완성형
                (ch >= 0x1100 && ch <= 0x11FF) || // 한글 자모
                (ch >= 0x3130 && ch <= 0x318F) // 한글 호환 자모
        );
    }

    private boolean containsJapanese(String text) {
        // 히라가나나 가타카나가 있으면 확실히 일본어
        boolean hasHiraganaKatakana = text.chars().anyMatch(ch -> (ch >= 0x3040 && ch <= 0x309F) || // 히라가나
                (ch >= 0x30A0 && ch <= 0x30FF) // 가타카나
        );

        if (hasHiraganaKatakana) {
            return true;
        }

        // 한자만 있는 경우: 한국어가 포함되어 있으면 한국어로 판단
        boolean hasKorean = containsKorean(text);
        if (hasKorean) {
            return false; // 한국어가 포함되어 있으면 일본어가 아님
        }

        // 한국어가 없고 한자만 있으면 일본어일 가능성
        return text.chars().anyMatch(ch -> ch >= 0x4E00 && ch <= 0x9FAF);
    }

    private boolean containsChinese(String text) {
        return text.chars().anyMatch(ch -> (ch >= 0x4E00 && ch <= 0x9FFF) || // CJK 통합 한자
                (ch >= 0x3400 && ch <= 0x4DBF) || // CJK 확장 A
                (ch >= 0x20000 && ch <= 0x2A6DF) || // CJK 확장 B
                (ch >= 0x2A700 && ch <= 0x2B73F) || // CJK 확장 C
                (ch >= 0x2B740 && ch <= 0x2B81F) || // CJK 확장 D
                (ch >= 0x2B820 && ch <= 0x2CEAF) || // CJK 확장 E
                (ch >= 0xF900 && ch <= 0xFAFF) || // CJK 호환 한자
                (ch >= 0x2F800 && ch <= 0x2FA1F) // CJK 호환 한자 보충
        );
    }

    private boolean isEnglishText(String text) {
        // 영어 알파벳이 대부분을 차지하는지 확인
        long englishChars = text.chars().filter(ch -> (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z')).count();
        long totalChars = text.replaceAll("\\s", "").length();
        return totalChars > 0 && (englishChars * 1.0 / totalChars) > 0.7; // 70% 이상이 영어
    }

    private String generateStableHash(String text) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(text.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            return String.valueOf(text.hashCode());
        }
    }

    private String serializeResponse(Object response) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(response);
    }

    private Object deserializeResponse(String serializedResponse, Class<?> responseClass) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.readValue(serializedResponse, responseClass);
    }

    // 내부 클래스들
    private static class FieldTextPair {
        final Field field;
        final Object parentObject;
        final Object originalValue;
        final FieldType fieldType;

        FieldTextPair(Field field, Object parentObject, Object originalValue, FieldType fieldType) {
            this.field = field;
            this.parentObject = parentObject;
            this.originalValue = originalValue;
            this.fieldType = fieldType;
        }
    }

    private enum FieldType {
        STRING, STRING_LIST
    }
}