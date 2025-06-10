package com.on_bapsang.backend.dto;

import com.on_bapsang.backend.entity.Post;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class PostDetail {
    private final Long id;
    private final String title;
    private final String content;
    private final String recipeTag;
    private final String recipeId;
    private final String recipeImageUrl;
    private final String imageUrl;
    private final String nickname;
    private final String profileImage;
    private final int scrapCount;
    private final int commentCount;
    private final Double x;
    private final Double y;
    private final LocalDateTime createdAt;

    public PostDetail(Post post, String imageUrl, String recipeImageUrl) {
        this.id = post.getId();
        this.title = post.getTitle();
        this.content = post.getContent();
        this.recipeTag = post.getRecipeTag();
        this.recipeId = post.getRecipeId();
        this.recipeImageUrl = recipeImageUrl;
        this.imageUrl = imageUrl;
        this.nickname = post.getUser().getNickname();
        this.profileImage = post.getUser().getProfileImage();
        this.scrapCount = post.getScrapCount();
        this.commentCount = post.getCommentCount();
        this.x = post.getX();
        this.y = post.getY();
        this.createdAt = post.getCreatedAt();
    }

}
