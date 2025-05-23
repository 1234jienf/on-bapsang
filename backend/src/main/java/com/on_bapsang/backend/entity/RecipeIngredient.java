package com.on_bapsang.backend.entity;


import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "RecipeIngredient")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RecipeIngredient {

    @EmbeddedId
    private RecipeIngredientKey id;

    @Column(nullable = false)
    private String amount;

    // @MapsId("recipeId")
    // @ManyToOne(fetch = FetchType.LAZY)
    // @JoinColumn(name = "recipe_id")
    // private Recipe recipe;
    //
    // @MapsId("ingredientId")
    // @ManyToOne(fetch = FetchType.LAZY)
    // @JoinColumn(name = "ingredient_id")
    // private IngredientMaster ingredient;
}
