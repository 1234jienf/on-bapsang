package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.mypage.MyPost;
import com.on_bapsang.backend.dto.mypage.ScrappedPost;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.repository.PostRepository;
import com.on_bapsang.backend.util.ImageUploader;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MyPageService {

    private final PostRepository postRepository;
    private final ImageUploader imageUploader;

    public Page<MyPost> getMyPosts(User user, Pageable pageable) {
        Page<MyPost> page = postRepository.findMyPostsByUser(user.getUserId(), pageable);
        List<MyPost> modified = page.getContent().stream().map(post -> {
            String url = post.getImageUrl() != null
                    ? imageUploader.generatePresignedUrl(post.getImageUrl(), 60)
                    : null;
            post.setImageUrl(url);
            return post;
        }).toList();
        return new PageImpl<>(modified, pageable, page.getTotalElements());
    }

    public Page<ScrappedPost> getScrappedPosts(User user, Pageable pageable) {
        try {
            Page<ScrappedPost> page = postRepository.findScrappedPostsByUser(user.getUserId(), pageable);
            List<ScrappedPost> modified = page.getContent().stream().map(post -> {
                String url = post.getImageUrl() != null
                        ? imageUploader.generatePresignedUrl(post.getImageUrl(), 60)
                        : null;
                post.setImageUrl(url);
                return post;
            }).toList();
            return new PageImpl<>(modified, pageable, page.getTotalElements());
        } catch (Exception e) {
            e.printStackTrace(); // 실제 예외 로그 확인
            throw e;
        }
    }

}
