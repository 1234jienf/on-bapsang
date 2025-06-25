package com.on_bapsang.backend.dto;

import com.on_bapsang.backend.i18n.Translatable;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class RecipeTagSuggestion {
    private String recipeId;

    @Translatable
    private String name;

    private String imageUrl;
}
