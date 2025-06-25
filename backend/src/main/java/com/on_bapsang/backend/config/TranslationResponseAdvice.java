package com.on_bapsang.backend.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.on_bapsang.backend.i18n.Translatable;
import com.on_bapsang.backend.service.TranslationService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

import java.lang.reflect.Field;
import java.util.IdentityHashMap;
import java.util.Set;
import java.util.Collections;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

@ControllerAdvice
@RequiredArgsConstructor
public class TranslationResponseAdvice implements ResponseBodyAdvice<Object> {

    private final TranslationService translationService;

    @Override
    public boolean supports(MethodParameter returnType, Class converterType) {
        // API 응답에만 적용 (HTML 페이지 제외)
        return returnType.getContainingClass().getPackageName().contains("controller");
    }

    @Override
    public Object beforeBodyWrite(Object body,
            MethodParameter returnType,
            MediaType selectedContentType,
            Class selectedConverterType,
            ServerHttpRequest request,
            ServerHttpResponse response) {

        // 프론트에서 보낸 언어 (예: X-Language: JA)
        String lang = request.getHeaders().getFirst("X-Language");
        if (lang == null || lang.equalsIgnoreCase("KO"))
            return body; // 한국어는 번역 안 함

        try {
            // 번역 가능한 필드가 있는지 먼저 확인
            if (!hasTranslatableFields(body)) {
                return body;
            }

            // 번역 수행 (타임아웃 3초)
            CompletableFuture<Void> translationFuture = CompletableFuture.runAsync(() -> {
                try {
                    translateRecursively(body, lang);
                } catch (Exception e) {
                    System.err.println("번역 실패: " + e.getMessage());
                }
            });

            // 최대 3초 대기
            translationFuture.get(3, TimeUnit.SECONDS);

        } catch (Exception e) {
            // 오류 시 번역하지 않고 원문 그대로 전달
            System.err.println("번역 타임아웃 또는 실패: " + e.getMessage());
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
                if (hasTranslatableFields(element, visited)) {
                    return true;
                }
            }
        } else if (!isSkippable(obj)) {
            Class<?> clazz = obj.getClass();
            for (Field field : clazz.getDeclaredFields()) {
                if (field.isAnnotationPresent(Translatable.class)) {
                    return true;
                }

                try {
                    field.setAccessible(true);
                    Object fieldValue = field.get(obj);
                    if (hasTranslatableFields(fieldValue, visited)) {
                        return true;
                    }
                } catch (Exception e) {
                    // 접근 불가능한 필드는 무시
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
        } else if (isSkippable(obj)) {
            return; // String, Number, Boolean, Enum, 등은 skip
        } else {
            Class<?> clazz = obj.getClass();
            for (Field field : clazz.getDeclaredFields()) {
                field.setAccessible(true);
                Object fieldValue = field.get(obj);
                if (fieldValue == null)
                    continue;

                if (field.isAnnotationPresent(Translatable.class)) {
                    if (fieldValue instanceof String original) {
                        String translated = translationService.translate(original, lang);
                        field.set(obj, translated);
                    }
                } else {
                    translateRecursively(fieldValue, lang, visited);
                }
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
