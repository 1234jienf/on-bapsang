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
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

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
        log.debug("Translation requested for path: {}, language: {}", requestPath, lang);

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

            // 타임아웃을 20초로 증가 (개별 번역 재시도 고려)
            future.get(20, TimeUnit.SECONDS);

            long duration = System.currentTimeMillis() - startTime;
            log.info("Translation completed in {}ms for language: {}", duration, lang);

        } catch (Exception e) {
            log.error("Translation timeout or failure for path: {}, language: {}, error: {}",
                    requestPath, lang, e.getMessage());
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
                    textsToTranslate.add(original);
                    fieldTextPairs.add(new FieldTextPair(field, obj, original, FieldType.STRING));
                } else if (fieldValue instanceof List<?> list && !list.isEmpty() && list.get(0) instanceof String) {
                    for (String item : (List<String>) list) {
                        if (item != null && !item.trim().isEmpty()) {
                            textsToTranslate.add(item);
                        }
                    }
                    fieldTextPairs.add(new FieldTextPair(field, obj, list, FieldType.STRING_LIST));
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

            if (!failedTexts.isEmpty()) {
                log.info("Batch translation failed for {} texts, retrying individually", failedTexts.size());

                // 개별 번역으로 재시도
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