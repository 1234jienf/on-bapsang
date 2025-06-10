package com.on_bapsang.backend.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PostRequest {
    private String title;
    private String content;
    private String recipeTag;
    private String recipeId;
    private Double x;
    private Double y;
}
