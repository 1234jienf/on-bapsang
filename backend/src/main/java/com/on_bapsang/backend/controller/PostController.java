package com.on_bapsang.backend.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.on_bapsang.backend.dto.*;
import com.on_bapsang.backend.entity.Post;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.security.UserDetailsImpl;
import com.on_bapsang.backend.service.PostService;
import com.on_bapsang.backend.util.ImageUploader;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/community/posts")
public class PostController {

    private final PostService postService;
    private final ImageUploader imageUploader;

    // 글 작성
    @PostMapping
    public ResponseEntity<?> createPost(
            @RequestPart("data") String data,
            @RequestPart(value = "image", required = false) MultipartFile image,
            @AuthenticationPrincipal UserDetailsImpl userDetails
    ) {
        ObjectMapper objectMapper = new ObjectMapper();
        PostRequest request;
        try {
            request = objectMapper.readValue(data, PostRequest.class);
        } catch (JsonProcessingException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400,"잘못된 데이터 형식입니다."));
        }

        User user = userDetails.getUser();
        String imageUrl = (image != null && !image.isEmpty()) ? imageUploader.upload(image) : null;
        Post savedPost = postService.create(request, user, imageUrl);
        return ResponseEntity.ok(ApiResponse.success("게시글 작성 완료", savedPost.getId()));
    }


    // 레시피 db 조회
    @GetMapping("/autocomplete")
    public ResponseEntity<ApiResponse<List<RecipeTagSuggestion>>> getRecipeTags(@RequestParam String keyword) {
        List<RecipeTagSuggestion> suggestions = postService.getRecipeTagSuggestions(keyword);
        return ResponseEntity.ok(ApiResponse.success("레시피 태그 조회 성공", suggestions));
    }



    // 글 목록 조회
    @GetMapping
    public ResponseEntity<?> getPosts(
            @RequestParam(required = false) String keyword,
            @PageableDefault(size = 9, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable,
            @AuthenticationPrincipal UserDetailsImpl userDetails
    ) {
        User user = userDetails.getUser();
        Page<PostSummaryWithScrap> posts = postService.getPosts(keyword, pageable, user);
        return ResponseEntity.ok(ApiResponse.success("게시글 목록 조회 성공", posts));
    }



    // 단일 글 조회
    @GetMapping("/{id}")
    public ResponseEntity<?> getPost(@PathVariable Long id,
                                     @AuthenticationPrincipal UserDetailsImpl userDetails) {
        if (userDetails != null) {
            return ResponseEntity.ok(ApiResponse.success("게시글 조회 성공",
                    postService.getPostById(id, userDetails.getUser())));
        } else {
            return ResponseEntity.ok(ApiResponse.success("게시글 조회 성공",
                    postService.getPostById(id)));
        }
    }



    // 게시글 수정
    @PatchMapping("/{id}")
    public ResponseEntity<?> updatePost(
            @PathVariable Long id,
            @RequestPart("data") PostRequest request,
            @RequestPart(value = "image", required = false) MultipartFile image,
            @AuthenticationPrincipal UserDetailsImpl userDetails
    ) {
        User user = userDetails.getUser();
        String imageUrl = (image != null && !image.isEmpty()) ? imageUploader.upload(image) : null;
        Post updated = postService.update(id, request, user, imageUrl);
        return ResponseEntity.ok(ApiResponse.success("게시글 수정 완료", updated.getId()));

    }

    // 게시글 삭제
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePost(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetailsImpl userDetails
    ) {
        User user = userDetails.getUser();
        postService.delete(id, user);
        return ResponseEntity.ok(ApiResponse.success("게시글 삭제 완료"));

    }



}
