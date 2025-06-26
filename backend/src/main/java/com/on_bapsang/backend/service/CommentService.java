package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.CommentRequest;
import com.on_bapsang.backend.dto.CommentResponse;
import com.on_bapsang.backend.entity.Comment;
import com.on_bapsang.backend.entity.Post;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.repository.CommentRepository;
import com.on_bapsang.backend.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.on_bapsang.backend.util.ImageUploader;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final PostRepository postRepository;
    private final ImageUploader imageUploader;

    // 댓글 작성 (대댓글 포함)
    @Transactional
    public Comment createComment(Long postId, String content, Long parentId, User user) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 존재하지 않습니다."));

        Comment parent = null;
        if (parentId != null) {
            parent = commentRepository.findById(parentId)
                    .orElseThrow(() -> new IllegalArgumentException("부모 댓글이 존재하지 않습니다."));
        }

        Comment comment = Comment.builder()
                .content(content)
                .user(user)
                .post(post)
                .parent(parent)
                .build();

        post.setCommentCount(post.getCommentCount() + 1);
        return commentRepository.save(comment);
    }




    // 댓글 삭제
    @Transactional
    public void deleteComment(Long commentId, User user) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new IllegalArgumentException("해당 댓글이 존재하지 않습니다."));

        if (!comment.getUser().getUserId().equals(user.getUserId())) {
            throw new IllegalArgumentException("댓글 작성자만 삭제할 수 있습니다.");
        }

        // 댓글 수 감소
        Post post = comment.getPost();
        post.setCommentCount(post.getCommentCount() - 1);

        commentRepository.delete(comment);
    }


    // 특정 게시글의 최상위 댓글 목록 + 대댓글 포함 응답
    @Transactional(readOnly = true)
    public List<CommentResponse> getComments(Long postId, User currentUser) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("게시글을 찾을 수 없습니다."));

        List<Comment> topLevelComments = commentRepository.findByPostAndParentIsNullWithUserAndReplies(post);

        return topLevelComments.stream()
                .map(comment -> buildCommentResponseWithChildren(comment, currentUser))
                .collect(Collectors.toList());
    }

    private CommentResponse buildCommentResponseWithChildren(Comment comment, User currentUser) {
        String profileImageUrl = comment.getUser().getProfileImage() != null
                ? imageUploader.generatePresignedUrl(comment.getUser().getProfileImage(), 120)
                : null;

        boolean isAuthor = comment.getUser().getUserId().equals(currentUser.getUserId());

        List<CommentResponse> children = comment.getChildren().stream()
                .map(child -> buildCommentResponseWithChildren(child, currentUser))
                .collect(Collectors.toList());

        return new CommentResponse(comment, profileImageUrl, children, isAuthor);
    }
}
