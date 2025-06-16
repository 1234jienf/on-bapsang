package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.entity.UserFavoriteDish;
import com.on_bapsang.backend.entity.Dish;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserFavoriteDishRepository extends JpaRepository<UserFavoriteDish, Long> {

    @Modifying
    @Transactional
    @Query("DELETE FROM UserFavoriteDish ufd WHERE ufd.user = :user")
    void deleteAllByUser(@Param("user") User user);

    // 중복 저장 방지용
    boolean existsByUserAndDish(User user, Dish dish);

    @Query("SELECT d.name FROM UserFavoriteDish ufd JOIN ufd.dish d WHERE ufd.user = :user")
    List<String> findDishNamesByUser(@Param("user") User user);

}
