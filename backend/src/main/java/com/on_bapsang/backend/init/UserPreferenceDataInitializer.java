package com.on_bapsang.backend.init;

import com.on_bapsang.backend.entity.Dish;
import com.on_bapsang.backend.entity.Ingredient;
import com.on_bapsang.backend.entity.Taste;
import com.on_bapsang.backend.repository.DishRepository;
import com.on_bapsang.backend.repository.IngredientRepository;
import com.on_bapsang.backend.repository.TasteRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;

@Component
@RequiredArgsConstructor
public class UserPreferenceDataInitializer {

    private final TasteRepository tasteRepository;
    private final IngredientRepository ingredientRepository;
    private final DishRepository dishRepository;

    @PostConstruct
    public void init() {
        insertTastes();
        insertIngredients();
        insertDishes();
    }

    private void insertTastes() {
        List<String> tastes = Arrays.asList("매운맛", "짠맛", "단맛", "쓴맛", "신맛", "감칠맛");
        for (String name : tastes) {
            if (!tasteRepository.existsByName(name)) {
                tasteRepository.save(new Taste(null, name));
            }
        }
    }

    private void insertIngredients() {
        List<String> meats = Arrays.asList("돼지고기", "닭고기", "소고기");
        List<String> vegetables = Arrays.asList("토마토", "양파", "오이", "양배추", "당근", "가지", "고추", "상추", "감자", "시금치");

        for (String name : meats) {
            if (!ingredientRepository.existsByName(name)) {
                ingredientRepository.save(new Ingredient(null, name, "육식"));
            }
        }
        for (String name : vegetables) {
            if (!ingredientRepository.existsByName(name)) {
                ingredientRepository.save(new Ingredient(null, name, "채식"));
            }
        }
    }

    private void insertDishes() {
        List<String> dishes = Arrays.asList("김치찌개", "된장찌개", "비빔밥", "불고기", "갈비", "삼계탕", "잡채", "김밥", "갈비탕", "칼국수");
        for (String name : dishes) {
            if (!dishRepository.existsByName(name)) {
                dishRepository.save(new Dish(null, name));
            }
        }
    }
}
