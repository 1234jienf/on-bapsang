package com.on_bapsang.backend.config;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.on_bapsang.backend.dto.IngredientInfo;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class IngredientDataLoader {

    private final Map<Long, IngredientInfo> ingredientMap = new HashMap<>();

    @PostConstruct
    public void init() {
        try {
            ObjectMapper mapper = new ObjectMapper();
            InputStream is = getClass().getResourceAsStream("/data/dummy_ingredients.json");
            List<JsonNode> nodes = mapper.readValue(is, new TypeReference<>() {
            });
            for (JsonNode node : nodes) {
                Long id = node.get("ingredient_id").asLong();
                IngredientInfo info = new IngredientInfo(
                        id,
                        node.get("ingredient").asText(),
                        node.get("material_type").asText(),
                        node.get("image_url").asText(),
                        node.get("sale_price").asInt(),
                        node.get("original_price").asInt(),
                        node.get("discount_rate").asText());
                ingredientMap.put(id, info);
            }
        } catch (Exception e) {
            throw new RuntimeException("더미 데이터 로딩 실패", e);
        }
    }

    public IngredientInfo getInfo(Long ingredientId) {
        return ingredientMap.get(ingredientId);
    }
}
