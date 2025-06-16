package com.on_bapsang.backend.dto.mypage;

import lombok.AllArgsConstructor;
import lombok.Getter;

import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
public class ScrappedPost {
    private Long postId;
    private String nickname;
    private String profileImage;
    private String title;
    private String content;
    private String imageUrl;
    private int scrapCount;
    private int commentCount;
    private LocalDateTime createdAt;
    private Double x;
    private Double y;
}

