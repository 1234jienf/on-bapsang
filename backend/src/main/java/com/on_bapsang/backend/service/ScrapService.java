package com.on_bapsang.backend.service;

import com.on_bapsang.backend.entity.Post;
import com.on_bapsang.backend.entity.Scrap;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.repository.PostRepository;
import com.on_bapsang.backend.repository.ScrapRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ScrapService {

    private final ScrapRepository scrapRepository;
    private final PostRepository postRepository;

    // 스크랩 토글
    @Transactional
    public boolean toggleScrap(Long postId, User user) {
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다."));

        Optional<Scrap> existingScrap = scrapRepository.findByUserAndPost(user, post);

        if (existingScrap.isPresent()) {
            scrapRepository.delete(existingScrap.get());
            post.setScrapCount(post.getScrapCount() - 1);
            return false; // 스크랩 취소됨
        } else {
            Scrap scrap = Scrap.builder().user(user).post(post).build();
            scrapRepository.save(scrap);
            post.setScrapCount(post.getScrapCount() + 1);
            return true; // 스크랩 성공
        }
}

    // 스크랩 여부 조회
    public boolean isScrapped(Post post, User user) {
        if (user == null) return false;
        return scrapRepository.existsByUserIdAndPostId(user.getUserId(), post.getId());
    }
}
