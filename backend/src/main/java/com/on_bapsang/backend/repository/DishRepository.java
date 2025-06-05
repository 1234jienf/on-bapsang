package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.Dish;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DishRepository extends JpaRepository<Dish, Long> {
    boolean existsByName(String name);
}
