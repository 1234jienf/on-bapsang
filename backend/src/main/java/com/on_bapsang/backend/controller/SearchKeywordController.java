package com.on_bapsang.backend.controller;

import com.on_bapsang.backend.dto.ApiResponse;
import com.on_bapsang.backend.security.UserDetailsImpl;
import com.on_bapsang.backend.service.SearchKeywordService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/keywords")
public class SearchKeywordController {

    private final SearchKeywordService searchKeywordService;

    @GetMapping("/recent")
    public ApiResponse<List<String>> getRecentKeywords(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        System.out.println(">>> userDetails: " + userDetails);
        if (userDetails == null) {
            throw new RuntimeException("userDetails가 null입니다");
        }

        Long userId = userDetails.getUser().getUserId();
        System.out.println(">>> userId: " + userId);

        List<String> recentKeywords = searchKeywordService.getRecentKeywords(userId);
        System.out.println(">>> result: " + recentKeywords);

        return ApiResponse.success("최근 검색어 조회 성공", recentKeywords);
    }

    // 인기 검색어 조회
    @GetMapping("/popular")
    public ApiResponse<List<String>> getPopularKeywords() {
        List<String> popularKeywords = searchKeywordService.getPopularKeywords(10);
        return ApiResponse.success("인기 검색어 조회 성공", popularKeywords);
    }



    // 내 최근 검색어 삭제
    @DeleteMapping("/recent")
    public ApiResponse<Void> deleteRecentKeywords(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        Long userId = userDetails.getUser().getUserId();
        searchKeywordService.clearRecentKeywords(userId);
        return ApiResponse.success("최근 검색어 삭제 성공", null);
    }
}
