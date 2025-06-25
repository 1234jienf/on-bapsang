package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.CartItem;
import com.on_bapsang.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByUser(User user);
    Optional<CartItem> findByUserAndIngredientId(User user, Long ingredientId);
}