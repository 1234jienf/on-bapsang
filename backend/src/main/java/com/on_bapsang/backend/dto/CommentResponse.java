// 댓글 응답용 DTO
package com.on_bapsang.backend.dto;

import com.on_bapsang.backend.entity.Comment;
import com.on_bapsang.backend.i18n.Translatable;
import lombok.Getter;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Getter
public class CommentResponse {
    private final Long id;

    @Translatable
    private final String content;

    private final String nickname;
    private final String profileImage;
    private final LocalDateTime createdAt;
    private final List<CommentResponse> children;
    private final boolean isAuthor;

    public CommentResponse(Comment comment, String profileImageUrl, List<CommentResponse> childResponses, boolean isAuthor) {
        this.id = comment.getId();
        this.content = comment.getContent();
        this.nickname = comment.getUser().getNickname();
        this.profileImage = profileImageUrl;
        this.createdAt = comment.getCreatedAt();
        this.children = childResponses;
        this.isAuthor = isAuthor;
    }
}
