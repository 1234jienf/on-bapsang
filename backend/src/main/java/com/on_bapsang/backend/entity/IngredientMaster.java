package com.on_bapsang.backend.entity;

import lombok.*;
import jakarta.persistence.*;

@Entity
@Table(name = "recipe_ingredient_master")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class IngredientMaster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ingredient_id")
    private Long ingredientId;

    @Column(nullable = false, unique = true)
    private String name;

    // DB 컬럼명 `type` 을 Java 필드 `category` 에 매핑
    @Column(name = "type")
    private String category;
}
