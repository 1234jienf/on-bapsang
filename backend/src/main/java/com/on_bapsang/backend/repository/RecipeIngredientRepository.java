package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.Recipe;
import com.on_bapsang.backend.entity.RecipeIngredient;
import com.on_bapsang.backend.entity.RecipeIngredientKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RecipeIngredientRepository
        extends JpaRepository<RecipeIngredient, RecipeIngredientKey> {

    /**
     * 재료 이름만 꺼내기 (IngredientMaster.name)
     */
    @Query("SELECT im.name FROM RecipeIngredient ri " +
            " JOIN ri.ingredientMaster im " +
            " WHERE ri.id.recipeId = :recipeId")
    List<String> findIngredientNamesByRecipeId(@Param("recipeId") String recipeId);

    /**
     * RecipeIngredient 전체 엔티티 + IngredientMaster 페치 조인
     */
    @Query("SELECT ri FROM RecipeIngredient ri " +
            " JOIN FETCH ri.ingredientMaster " +
            " WHERE ri.id.recipeId = :recipeId")
    List<RecipeIngredient> findByRecipeId(@Param("recipeId") String recipeId);

    @Query("SELECT ri.id.ingredientId FROM RecipeIngredient ri WHERE ri.recipe.recipeId = :recipeId")
    List<Long> findIngredientIdsByRecipe(@Param("recipeId") String recipeId);


    @Query("SELECT ri.recipe.recipeId FROM RecipeIngredient ri WHERE ri.ingredientMaster.ingredientId = :ingredientId")
    List<String> findRecipeIdsByIngredientId(@Param("ingredientId") Long ingredientId);
}