package com.on_bapsang.backend.controller;

import com.on_bapsang.backend.dto.ApiResponse;
import com.on_bapsang.backend.dto.CommentRequest;
import com.on_bapsang.backend.entity.Comment;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.security.UserDetailsImpl;
import com.on_bapsang.backend.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/community/comments")
public class CommentController {

    private final CommentService commentService;

    // 댓글 작성
    @PostMapping("/{postId}")
    public ResponseEntity<?> addComment(@PathVariable Long postId,
                                        @RequestBody CommentRequest request,
                                        @AuthenticationPrincipal UserDetailsImpl userDetails) {
        Comment comment = commentService.createComment(postId, request.getContent(), request.getParentId(), userDetails.getUser());
        return ResponseEntity.ok(ApiResponse.success("댓글 작성 완료", comment.getId()));

    }


    // 댓글 삭제
    @DeleteMapping("/{commentId}")
    public ResponseEntity<?> deleteComment(@PathVariable Long commentId,
                                           @AuthenticationPrincipal UserDetailsImpl userDetails) {
        commentService.deleteComment(commentId, userDetails.getUser());
        return ResponseEntity.ok(ApiResponse.success("댓글이 삭제되었습니다."));
    }


    // 댓글 조회
    @GetMapping("/{postId}")
    public ResponseEntity<?> getComments(@PathVariable Long postId,
                                         @AuthenticationPrincipal UserDetailsImpl userDetails) {
        User user = (userDetails != null) ? userDetails.getUser() : null;
        return ResponseEntity.ok(
                ApiResponse.success("댓글 목록 조회 성공", commentService.getComments(postId, user))
        );
    }


}
