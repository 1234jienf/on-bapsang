package com.on_bapsang.backend.dto.mypage;

import com.on_bapsang.backend.i18n.Translatable;
import lombok.AllArgsConstructor;
import lombok.Getter;

import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
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

    private boolean scrapped;

    // JPA에서 사용하는 생성자
    public ScrappedPost(Long postId, String nickname, String profileImage,
                        String title, String content, String imageUrl,
                        int scrapCount, int commentCount,
                        LocalDateTime createdAt, Double x, Double y) {
        this.postId = postId;
        this.nickname = nickname;
        this.profileImage = profileImage;
        this.title = title;
        this.content = content;
        this.imageUrl = imageUrl;
        this.scrapCount = scrapCount;
        this.commentCount = commentCount;
        this.createdAt = createdAt;
        this.x = x;
        this.y = y;
        this.scrapped = false; // 기본값
    }

    // 필요시 lombok builder 등 추가 가능
}
