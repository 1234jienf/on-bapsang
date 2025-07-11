package com.on_bapsang.backend.dto;

import com.on_bapsang.backend.entity.Post;
import com.on_bapsang.backend.i18n.Translatable;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class PostSummaryWithScrap {
    private final Long id;
    @Translatable
    private final String title;
    @Translatable
    private final String content;
    private final String imageUrl;
    private final String nickname;
    private final String profileImage;
    private final int scrapCount;
    private final int commentCount;
    private final LocalDateTime createdAt;
    private final boolean isScrapped;
    private final Double x;
    private final Double y;

    public PostSummaryWithScrap(Post post, boolean isScrapped,
            String imageUrl, String profileImageUrl) {
        this.id = post.getId();
        this.title = post.getTitle();
        this.content = post.getContent();
        this.imageUrl = imageUrl;
        this.nickname = post.getUser().getNickname();
        this.profileImage = profileImageUrl;
        this.scrapCount = post.getScrapCount();
        this.commentCount = post.getCommentCount();
        this.createdAt = post.getCreatedAt();
        this.isScrapped = isScrapped;
        this.x = post.getX();
        this.y = post.getY();
    }
}
