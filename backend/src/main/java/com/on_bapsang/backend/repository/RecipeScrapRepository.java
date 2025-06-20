package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.Recipe;
import com.on_bapsang.backend.entity.RecipeScrap;
import com.on_bapsang.backend.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface RecipeScrapRepository extends JpaRepository<RecipeScrap, Long> {
    boolean existsByUserAndRecipe(User user, Recipe recipe);
    void deleteByUserAndRecipe(User user, Recipe recipe);
    List<RecipeScrap> findAllByUser(User user);
    Optional<RecipeScrap> findByUserAndRecipe(User user, Recipe recipe);
    @Query(value = "SELECT rs FROM RecipeScrap rs JOIN FETCH rs.recipe WHERE rs.user = :user",
            countQuery = "SELECT count(rs) FROM RecipeScrap rs WHERE rs.user = :user")
    Page<RecipeScrap> findAllWithRecipeByUser(@Param("user") User user, Pageable pageable);

}
