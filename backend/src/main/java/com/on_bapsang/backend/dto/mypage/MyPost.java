package com.on_bapsang.backend.dto.mypage;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@AllArgsConstructor
public class MyPost {
    private Long postId;
    private String title;
    private String content;
    private String imageUrl;
    private int scrapCount;
    private int commentCount;
    private LocalDateTime createdAt;
    private Double x;
    private Double y;
}


