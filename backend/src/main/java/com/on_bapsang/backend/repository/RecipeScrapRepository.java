package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.Recipe;
import com.on_bapsang.backend.entity.RecipeScrap;
import com.on_bapsang.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface RecipeScrapRepository extends JpaRepository<RecipeScrap, Long> {
    boolean existsByUserAndRecipe(User user, Recipe recipe);
    void deleteByUserAndRecipe(User user, Recipe recipe);
    List<RecipeScrap> findAllByUser(User user);
}
