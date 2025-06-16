package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.entity.UserFavoriteIngredient;
import com.on_bapsang.backend.entity.Ingredient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserFavoriteIngredientRepository extends JpaRepository<UserFavoriteIngredient, Long> {

    @Modifying
    @Transactional
    @Query("DELETE FROM UserFavoriteIngredient ufi WHERE ufi.user = :user")
    void deleteAllByUser(@Param("user") User user);

    // 중복 저장 방지용 exists 메서드 추가
    boolean existsByUserAndIngredient(User user, Ingredient ingredient);
    @Query("SELECT i.ingredientId FROM UserFavoriteIngredient ufi JOIN ufi.ingredient i WHERE ufi.user = :user")
    List<Long> findIngredientIdsByUser(@Param("user") User user);

}
