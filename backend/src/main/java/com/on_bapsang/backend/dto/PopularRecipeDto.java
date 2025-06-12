package com.on_bapsang.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

@Getter
@AllArgsConstructor
public class PopularRecipeDto {
    private String recipeId;
    private String name;
    private List<String> ingredients;
    private String description;
    private String review;
    private String time;
    private String difficulty;
    private String portion;
    private String method;
    private String materialType;
    private String imageUrl;
    private int postCount; // 후기 수
}
