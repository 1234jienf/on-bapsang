package com.on_bapsang.backend.dto;

import com.on_bapsang.backend.entity.Post;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class PostSummary {

    private Long id;
    private String title;
    private String imageUrl;
    private int scrapCount;
    private int commentCount;
    private LocalDateTime createdAt;
    private String nickname;
    private Double x;
    private Double y;

    public PostSummary(Long id, String title, String imageUrl, int scrapCount,
                       int commentCount, LocalDateTime createdAt, String nickname,
                       Double x, Double y) {
        this.id = id;
        this.title = title;
        this.imageUrl = imageUrl;
        this.scrapCount = scrapCount;
        this.commentCount = commentCount;
        this.createdAt = createdAt;
        this.nickname = nickname;
        this.x = x;
        this.y = y;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
