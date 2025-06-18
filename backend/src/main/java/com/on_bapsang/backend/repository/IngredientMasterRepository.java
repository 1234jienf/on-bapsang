package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.IngredientMaster;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface IngredientMasterRepository extends JpaRepository<IngredientMaster, Long> {
    Optional<IngredientMaster> findByName(String name);

    Optional<IngredientMaster> findByNameContaining(String name);

    @Query("SELECT i.name FROM IngredientMaster i WHERE i.ingredientId = :ingredientId")
    Optional<String> findNameByIngredientId(@Param("ingredientId") Long ingredientId);

    @Query("SELECT i FROM IngredientMaster i WHERE i.name LIKE %:name%")
    List<IngredientMaster> findAllByNameContaining(@Param("name") String name);


}