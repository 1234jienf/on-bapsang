package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.entity.UserDailyRecipe;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.Optional;

public interface UserDailyRecipeRepository extends JpaRepository<UserDailyRecipe, Long> {
    Optional<UserDailyRecipe> findByUserAndDate(User user, LocalDate date);
}