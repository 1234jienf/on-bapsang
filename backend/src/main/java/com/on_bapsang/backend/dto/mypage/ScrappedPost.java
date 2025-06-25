package com.on_bapsang.backend.dto.mypage;

import com.on_bapsang.backend.i18n.Translatable;
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

    @Translatable
    private String title;

    @Translatable
    private String content;

    private String imageUrl;
    private int scrapCount;
    private int commentCount;
    private LocalDateTime createdAt;
    private Double x;
    private Double y;
}

