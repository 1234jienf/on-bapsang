package com.on_bapsang.backend.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.on_bapsang.backend.dto.IngredientMarketMappingDto;
import com.on_bapsang.backend.repository.IngredientMasterRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.*;

@Service
@RequiredArgsConstructor
public class IngredientMarketMappingService {

    private final IngredientMasterRepository ingredientMasterRepository;

    // ✅ 여러 개의 market_item_id를 저장할 수 있도록 List<Integer>로 변경
    private Map<Long, List<Integer>> ingredientToMarketItemMap = new HashMap<>();
    private Map<Long, String> ingredientIdToNameMap = new HashMap<>();

    @PostConstruct
    public void loadMapping() throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        TypeReference<List<IngredientMarketMappingDto>> typeRef = new TypeReference<>() {};

        List<IngredientMarketMappingDto> list = mapper.readValue(
                new ClassPathResource("ingredient_market_mapping.json").getInputStream(),
                typeRef
        );

        for (IngredientMarketMappingDto dto : list) {
            Long ingredientId = dto.getIngredient_id();
            Integer marketItemId = dto.getMarket_item_id();

            // ✅ 중복 매핑 지원을 위해 리스트에 추가
            ingredientToMarketItemMap
                    .computeIfAbsent(ingredientId, k -> new ArrayList<>())
                    .add(marketItemId);

            ingredientIdToNameMap.put(ingredientId, dto.getIngredient_name());
        }
    }

    // ✅ 가장 첫 번째 market_item_id만 반환
    public Integer getMarketItemId(Long ingredientId) {
        List<Integer> ids = ingredientToMarketItemMap.get(ingredientId);
        if (ids == null || ids.isEmpty()) {
            return null;
        }
        return ids.get(0);
    }

    public String getIngredientName(Long ingredientId) {
        String name = ingredientIdToNameMap.get(ingredientId);
        if (name != null) {
            return name;
        }

        return ingredientMasterRepository.findNameByIngredientId(ingredientId)
                .orElse("Unknown Ingredient (" + ingredientId + ")");
    }
}
