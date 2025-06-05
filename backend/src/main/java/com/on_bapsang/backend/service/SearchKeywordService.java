package com.on_bapsang.backend.service;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class SearchKeywordService {

    private final RedisTemplate<String, String> redisTemplate;

    private static final String RECENT_KEY_PREFIX = "recent:";
    private static final String POPULAR_KEY = "popular";

    @PostConstruct
    public void init() {
        System.out.println(">>> RedisTemplate in SearchKeywordService: " + redisTemplate);
    }

    /**
     * 사용자별 최근 검색어 저장
     */
    public void saveRecentKeyword(Long userId, String keyword) {
        String key = RECENT_KEY_PREFIX + userId;
        redisTemplate.opsForList().remove(key, 0, keyword); // 중복 제거
        redisTemplate.opsForList().leftPush(key, keyword);  // 앞에 삽입
        redisTemplate.opsForList().trim(key, 0, 9); // 최대 10개로 제한
    }

    /**
     * 전체 인기 검색어 점수 증가 (중복 포함)
     */
    public void increaseKeywordScore(String keyword) {
        redisTemplate.opsForZSet().incrementScore(POPULAR_KEY, keyword, 1);
    }

    /**
     * 사용자별 최근 검색어 목록 조회
     */
    public List<String> getRecentKeywords(Long userId) {
        String key = "recent:" + userId;
        System.out.println(">>> RedisTemplate: " + redisTemplate);
        try {
            return redisTemplate.opsForList().range(key, 0, 9);
        } catch (Exception e) {
            System.out.println(">>> Redis 오류: " + e.getClass().getName() + " / " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Redis 오류: " + e.getMessage());
        }
    }


    /**
     * 인기 검색어 목록 조회 (점수 높은 순)
     */
    public List<String> getPopularKeywords(int count) {
        Set<String> raw = redisTemplate.opsForZSet().reverseRange(POPULAR_KEY, 0, count - 1);
        return raw == null ? List.of() : List.copyOf(raw); // 순서를 유지한 List로 변환
    }


    /**
     * 사용자별 최근 검색어 전체 삭제 (선택 사항)
     */
    public void clearRecentKeywords(Long userId) {
        String key = RECENT_KEY_PREFIX + userId;
        redisTemplate.delete(key);
    }
}
