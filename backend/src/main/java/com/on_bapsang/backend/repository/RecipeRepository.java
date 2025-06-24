package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.Recipe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.List;

public interface RecipeRepository extends JpaRepository<Recipe, String> {

    Page<Recipe> findByNameContaining(String name, Pageable pageable);

    Page<Recipe> findByMaterialTypeContaining(String category, Pageable pageable);

    @Query(value = "SELECT * FROM recipe WHERE name LIKE CONCAT('%', :keyword, '%') COLLATE utf8mb4_general_ci LIMIT 10", nativeQuery = true)
    List<Recipe> findTop10ByNameContainingIgnoreCase(@Param("keyword") String keyword);

    @Query(value = "SELECT * FROM recipe " +
            "WHERE CAST(recipe_id AS UNSIGNED) BETWEEN :start AND :end", nativeQuery = true)
    List<Recipe> findByRecipeIdBetween(@Param("start") Long start, @Param("end") Long end);

}

