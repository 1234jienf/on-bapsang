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
import java.util.Collections;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import java.util.concurrent.atomic.AtomicInteger;

@Slf4j
@ControllerAdvice
@RequiredArgsConstructor
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

        log.info("=== Translation Request Started ===");
        log.info("Target Language: {}", lang);
        log.info("Method: {}.{}", returnType.getContainingClass().getSimpleName(),
                returnType.getMethod().getName());

        try {
            if (!hasTranslatableFields(body)) {
                log.info("No translatable fields found, skipping translation");
                return body;
            }

            log.info("Translatable fields detected, starting translation process");

            AtomicInteger translatedCount = new AtomicInteger(0);
            AtomicInteger failedCount = new AtomicInteger(0);

            CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
                try {
                    translateRecursively(body, lang, translatedCount, failedCount);
                    log.info("Translation completed - Success: {}, Failed: {}",
                            translatedCount.get(), failedCount.get());
                } catch (Exception e) {
                    log.error("Translation process failed completely", e);
                    failedCount.incrementAndGet();
                }
            });

            // 15초 타임아웃으로 증가 (더 많은 시간 확보)
            future.get(15, TimeUnit.SECONDS);

            log.info("=== Translation Request Completed ===");
            log.info("Final stats - Translated: {}, Failed: {}",
                    translatedCount.get(), failedCount.get());

        } catch (TimeoutException e) {
            log.error("Translation timeout (15s) for language: {}", lang, e);
            // 타임아웃이어도 기존 body 반환 (부분 번역이라도 유지)
        } catch (Exception e) {
            log.error("Translation error for language: {}", lang, e);
            // 오류가 있어도 기존 body 반환
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
                try {
                    field.setAccessible(true);
                    if (field.isAnnotationPresent(Translatable.class)) {
                        return true;
                    }
                    Object fieldValue = field.get(obj);
                    if (hasTranslatableFields(fieldValue, visited))
                        return true;
                } catch (Exception e) {
                    log.debug("Error checking field {}: {}", field.getName(), e.getMessage());
                }
            }
        }

        return false;
    }

    private void translateRecursively(Object obj, String lang, AtomicInteger successCount, AtomicInteger failureCount)
            throws IllegalAccessException {
        translateRecursively(obj, lang, Collections.newSetFromMap(new IdentityHashMap<>()), successCount, failureCount);
    }

    private void translateRecursively(Object obj, String lang, Set<Object> visited, AtomicInteger successCount,
            AtomicInteger failureCount) throws IllegalAccessException {
        if (obj == null || visited.contains(obj))
            return;
        visited.add(obj);

        if (obj instanceof Iterable<?> iterable) {
            log.debug("Processing iterable with {} elements",
                    iterable instanceof List ? ((List<?>) iterable).size() : "unknown");
            for (Object element : iterable) {
                try {
                    translateRecursively(element, lang, visited, successCount, failureCount);
                } catch (Exception e) {
                    log.error("Failed to translate element in iterable", e);
                    failureCount.incrementAndGet();
                }
            }
            return;
        }

        if (isSkippable(obj))
            return;

        Class<?> clazz = obj.getClass();
        log.debug("Processing object of type: {}", clazz.getSimpleName());

        for (Field field : clazz.getDeclaredFields()) {
            field.setAccessible(true);
            try {
                Object fieldValue = field.get(obj);
                if (fieldValue == null)
                    continue;

                if (field.isAnnotationPresent(Translatable.class)) {
                    log.debug("Found @Translatable field: {}.{}", clazz.getSimpleName(), field.getName());

                    if (fieldValue instanceof String original) {
                        try {
                            if (original.trim().isEmpty()) {
                                log.debug("Skipping empty string field: {}", field.getName());
                                continue;
                            }

                            log.debug("Translating string field '{}': '{}'", field.getName(), original);
                            String translated = translationService.translate(original, lang);
                            field.set(obj, translated);
                            successCount.incrementAndGet();

                            if (!original.equals(translated)) {
                                log.debug("Translation successful: '{}' -> '{}'", original, translated);
                            } else {
                                log.debug("Translation returned same text (possibly failed): '{}'", original);
                            }
                        } catch (Exception e) {
                            log.error("Failed to translate string field '{}' with value '{}'", field.getName(),
                                    original, e);
                            failureCount.incrementAndGet();
                            // 실패해도 원본 값 유지
                        }

                    } else if (fieldValue instanceof List<?> list && !list.isEmpty() && list.get(0) instanceof String) {
                        try {
                            log.debug("Translating list field '{}' with {} items", field.getName(), list.size());

                            List<String> stringList = (List<String>) list;
                            List<String> translatedList = stringList.stream()
                                    .map(item -> {
                                        try {
                                            if (item == null || item.trim().isEmpty()) {
                                                return item;
                                            }
                                            String result = translationService.translate(item, lang);
                                            log.debug("List item translated: '{}' -> '{}'", item, result);
                                            return result;
                                        } catch (Exception e) {
                                            log.error("Failed to translate list item: '{}'", item, e);
                                            failureCount.incrementAndGet();
                                            return item; // 실패 시 원본 반환
                                        }
                                    })
                                    .toList();

                            field.set(obj, translatedList);
                            successCount.addAndGet(translatedList.size());
                            log.debug("List field '{}' translation completed", field.getName());

                        } catch (Exception e) {
                            log.error("Failed to translate list field '{}'", field.getName(), e);
                            failureCount.incrementAndGet();
                        }
                    }

                } else if (fieldValue instanceof Iterable<?> nestedIterable) {
                    log.debug("Processing nested iterable field: {}", field.getName());
                    for (Object element : nestedIterable) {
                        try {
                            translateRecursively(element, lang, visited, successCount, failureCount);
                        } catch (Exception e) {
                            log.error("Failed to process nested element in field '{}'", field.getName(), e);
                            failureCount.incrementAndGet();
                        }
                    }
                } else {
                    try {
                        translateRecursively(fieldValue, lang, visited, successCount, failureCount);
                    } catch (Exception e) {
                        log.debug("Failed to process nested object in field '{}'", field.getName(), e);
                        // 중첩 객체 실패는 전체를 중단시키지 않음
                    }
                }

            } catch (Exception e) {
                log.error("Error processing field '{}' in class '{}'",
                        field.getName(), clazz.getSimpleName(), e);
                failureCount.incrementAndGet();
                // 개별 필드 실패가 전체 번역을 중단시키지 않도록 함
            }
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
}
