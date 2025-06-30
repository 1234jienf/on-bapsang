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

    @Query(value = """
            SELECT rs FROM RecipeScrap rs
            JOIN FETCH rs.recipe
            WHERE rs.user = :user
            """,
            countQuery = "SELECT count(rs) FROM RecipeScrap rs WHERE rs.user = :user")
    Page<RecipeScrap> findAllWithRecipeByUser(@Param("user") User user, Pageable pageable);


    /** 단건 존재 여부를 ID 값으로 검사 (영속성 컨텍스트 무관) */
    boolean existsByUser_UserIdAndRecipe_RecipeId(Long userId, String recipeId);

    /** 사용자가 스크랩한 recipeId 리스트만 뽑아오기 (목록 변환용) */
    @Query("select s.recipe.recipeId from RecipeScrap s where s.user.userId = :userId")
    List<String> findRecipeIdsByUserId(@Param("userId") Long userId);
}
