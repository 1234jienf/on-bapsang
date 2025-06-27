package com.on_bapsang.backend.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.on_bapsang.backend.dto.*;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.exception.CustomException;
import com.on_bapsang.backend.security.UserDetailsImpl;
import com.on_bapsang.backend.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.on_bapsang.backend.util.ImageUploader;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final ImageUploader imageUploader;

    @PostMapping("/signup")
    public ResponseEntity<ApiResponse<Void>> registerUser(
            @RequestPart("data") String data,
            @RequestPart(value = "profileImage", required = false) MultipartFile profileImage
    ) {
        SignupRequest request;
        try {
            ObjectMapper mapper = new ObjectMapper();
            request = mapper.readValue(data, SignupRequest.class);
        } catch (JsonProcessingException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(400, "잘못된 데이터 형식입니다."));
        }

        userService.registerUser(request, profileImage);
        return ResponseEntity.ok(ApiResponse.success("회원가입이 완료되었습니다."));
    }


    // UserController.java
    @GetMapping("/me")
    public ResponseEntity<ApiResponse<UserInfoResponse>> getMyInfo(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        if (userDetails == null) {
            throw new CustomException("인증된 사용자가 아닙니다.", HttpStatus.UNAUTHORIZED);
        }

        User user = userDetails.getUser();

        // 프로필 presigned URL 생성
        String profileUrl = user.getProfileImage() != null
                ? imageUploader.generatePresignedUrl(user.getProfileImage(), 120)
                : null;

        // response 객체 직접 생성
        UserInfoResponse response = new UserInfoResponse(user, profileUrl);
        return ResponseEntity.ok(ApiResponse.success("내 정보 조회 성공", response));
    }


    @DeleteMapping("/withdraw")
    public ResponseEntity<ApiResponse<Void>> withdraw(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        User user = userDetails.getUser();
        userService.withdraw(user);
        return ResponseEntity.ok(ApiResponse.success("회원 탈퇴가 완료되었습니다."));
    }

    @PatchMapping("/me")
    public ResponseEntity<ApiResponse<Void>> updateMyInfo(
            @AuthenticationPrincipal UserDetailsImpl userDetails,
            @RequestBody UpdateUserRequest request) {

        User user = userDetails.getUser();
        userService.updateUserInfo(user, request);
        return ResponseEntity.ok(ApiResponse.success("회원정보가 수정되었습니다."));
    }

    @GetMapping("/check-username")
    public ResponseEntity<ApiResponse<Boolean>> checkUsername(@RequestParam String username) {
        boolean isDuplicate = userService.isUsernameDuplicate(username);
        return ResponseEntity.ok(ApiResponse.success("아이디 중복 여부 확인", isDuplicate));
    }

    @PatchMapping("/language")
    public ResponseEntity<ApiResponse<Void>> updateLanguage(
            @AuthenticationPrincipal UserDetailsImpl userDetails,
            @RequestBody UpdateLanguageRequest request) {

        userService.updateLanguage(userDetails.getUser(), request.getCountry());
        return ResponseEntity.ok(ApiResponse.success("언어 설정이 변경되었습니다."));
    }




}
