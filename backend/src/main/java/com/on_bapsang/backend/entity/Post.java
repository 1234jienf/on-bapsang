package com.on_bapsang.backend.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class Post {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 글 제목
    @Column(nullable = false)
    private String title;

    // 글 내용 (본문)
    @Lob
    @Column(nullable = false)
    private String content;

    // 이미지 URL 또는 서버 경로
    @Column(length = 1000)
    private String imageUrl;

    // 자동완성으로 선택된 레시피 분류명
    private String recipeTag;

    // 레시피 아이디
    @Column(length = 32)
    private String recipeId;

    // 스크랩 수
    @Column(nullable = false)
    private int scrapCount = 0;

    // 댓글 수
    @Column(nullable = false)
    private int commentCount = 0;

    // 작성 시각
    private LocalDateTime createdAt;

    // 작성자 정보
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    // 작성 시간 자동 저장
    @PrePersist
    public void onPrePersist() {
        this.createdAt = LocalDateTime.now();
    }

    // 이미지 내 태그 좌표
    private Double x;
    private Double y;

    @OneToMany(mappedBy = "post", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<Comment> comments = new ArrayList<>();

    @OneToMany(mappedBy = "post", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<Scrap> scraps = new ArrayList<>();
}
