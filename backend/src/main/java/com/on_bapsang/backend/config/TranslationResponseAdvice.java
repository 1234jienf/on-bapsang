package com.on_bapsang.backend.config;

import com.on_bapsang.backend.i18n.Translatable;
import com.on_bapsang.backend.service.TranslationService;
import lombok.RequiredArgsConstructor;
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
        if (lang == null || lang.equalsIgnoreCase("KO"))
            return body;

        try {
            if (!hasTranslatableFields(body))
                return body;

            CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
                try {
                    translateRecursively(body, lang);
                } catch (Exception e) {
                    System.err.println("번역 실패: " + e.getMessage());
                }
            });

            future.get(3, TimeUnit.SECONDS); // 최대 3초 대기

        } catch (Exception e) {
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
                } else if (fieldValue instanceof List<?> list && !list.isEmpty() && list.get(0) instanceof String) {
                    List<String> translatedList = list.stream()
                            .map(item -> translationService.translate((String) item, lang))
                            .toList();
                    field.set(obj, translatedList);
                }
            } else if (fieldValue instanceof Iterable<?> nestedIterable) {
                for (Object element : nestedIterable) {
                    translateRecursively(element, lang, visited);
                }
            } else {
                translateRecursively(fieldValue, lang, visited);
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