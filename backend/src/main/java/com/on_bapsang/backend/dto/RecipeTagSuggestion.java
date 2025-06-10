package com.on_bapsang.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class RecipeTagSuggestion {
    private String recipeId;
    private String name;
    private String imageUrl;
}
