package com.on_bapsang.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "recipe")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Recipe {

    @Id
    @Column(name = "recipe_id", length = 32)
    private String recipeId;

    @Column(nullable = false)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String review;

    private String time;
    private String difficulty;
    private String portion;
    private String method;

    @Column(name = "material_type")
    private String materialType;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "instruction", columnDefinition = "TEXT")
    private String instruction;
}
