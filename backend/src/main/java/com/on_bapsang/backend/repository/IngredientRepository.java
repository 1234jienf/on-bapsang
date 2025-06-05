package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.Ingredient;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IngredientRepository extends JpaRepository<Ingredient, Long> {
    boolean existsByName(String name);
}
