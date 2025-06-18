package com.on_bapsang.backend.controller;

import com.on_bapsang.backend.dto.ApiResponse;
import com.on_bapsang.backend.dto.mypage.MyPost;
import com.on_bapsang.backend.dto.mypage.MyPostResponse;
import com.on_bapsang.backend.dto.mypage.ScrappedPost;
import com.on_bapsang.backend.dto.mypage.ScrappedRecipeResponse;
import com.on_bapsang.backend.security.UserDetailsImpl;
import com.on_bapsang.backend.service.MyPageService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;


@RestController
@RequiredArgsConstructor
@RequestMapping("/api/mypage")
public class MyPageController {

    private final MyPageService myPageService;

    @GetMapping("/posts")
    public ResponseEntity<ApiResponse<Page<MyPost>>> getMyPosts(
            @AuthenticationPrincipal UserDetailsImpl userDetails,
            @PageableDefault(size = 10, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable
    ) {
        Page<MyPost> posts = myPageService.getMyPosts(userDetails.getUser(), pageable);
        return ResponseEntity.ok(new ApiResponse<>(200, "내가 쓴 글 조회 성공", posts));
    }

    @GetMapping("/scraps")
    public ResponseEntity<ApiResponse<Page<ScrappedPost>>> getScrappedPosts(
            @AuthenticationPrincipal UserDetailsImpl userDetails,
            @PageableDefault(size = 10, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable
    ) {
        Page<ScrappedPost> posts = myPageService.getScrappedPosts(userDetails.getUser(), pageable);
        return ResponseEntity.ok(new ApiResponse<>(200, "스크랩한 글 조회 성공", posts));
    }

    @GetMapping("/scrap-recipes")
    public ResponseEntity<ApiResponse<ScrappedRecipeResponse>> getScrappedRecipes(
            @AuthenticationPrincipal UserDetailsImpl userDetails,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {

        ScrappedRecipeResponse response = myPageService.getScrappedRecipes(userDetails.getUser(), page, size);
        return ResponseEntity.ok(new ApiResponse<>(200, "스크랩한 레시피 조회 성공", response));
    }

}
