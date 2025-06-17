package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.dto.mypage.MyPost;
import com.on_bapsang.backend.dto.mypage.ScrappedPost;
import com.on_bapsang.backend.dto.PostSummary;
import com.on_bapsang.backend.dto.PostSummaryWithScrap;
import com.on_bapsang.backend.entity.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PostRepository extends JpaRepository<Post, Long> {


    // 검색어 기반 ID 페이징 조회
    @Query("SELECT p.id FROM Post p WHERE LOWER(p.title) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    Page<Long> findPostIdsByTitleKeyword(@Param("keyword") String keyword, Pageable pageable);

    // 검색어 없이 ID 페이징 조회
    @Query("SELECT p.id FROM Post p")
    Page<Long> findAllPostIds(Pageable pageable);

    // ID 리스트 기반으로 user를 fetch join하여 Post 조회
    @Query("SELECT p FROM Post p JOIN FETCH p.user WHERE p.id IN :ids")
    List<Post> findAllWithUserByIds(@Param("ids") List<Long> ids);

    @Query("SELECT p FROM Post p JOIN FETCH p.user " +
            "WHERE (:keyword IS NULL OR LOWER(p.title) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<Post> findPostsByKeywordWithUser(@Param("keyword") String keyword, Pageable pageable);



    // 마이페이지 내가 쓴 글
    @Query("SELECT new com.on_bapsang.backend.dto.mypage.MyPost(" +
            "p.id, u.nickname, u.profileImage, p.title, p.content, p.imageUrl, " +
            "p.scrapCount, p.commentCount, p.createdAt, p.x, p.y) " +
            "FROM Post p JOIN p.user u WHERE p.user.userId = :userId")
    Page<MyPost> findMyPostsByUser(@Param("userId") Long userId, Pageable pageable);


    // 마이페이지 스크랩한 글
    @Query("SELECT new com.on_bapsang.backend.dto.mypage.ScrappedPost(" +
            "p.id, u.nickname, u.profileImage, p.title, p.content, p.imageUrl, " +
            "p.scrapCount, p.commentCount, p.createdAt, p.x, p.y) " +
            "FROM Post p JOIN p.user u JOIN Scrap s ON s.post = p " +
            "WHERE s.user.userId = :userId")
    Page<ScrappedPost> findScrappedPostsByUser(@Param("userId") Long userId, Pageable pageable);

    // 인기 레시피 ID 조회
    @Query("SELECT p.recipeId, COUNT(p) as cnt " +
            "FROM Post p " +
            "WHERE p.recipeId IS NOT NULL " +
            "GROUP BY p.recipeId " +
            "ORDER BY cnt DESC")
    List<Object[]> findTopRecipeIdsByPostCount(Pageable pageable);


    @Query("SELECT new com.on_bapsang.backend.dto.PostSummary(" +
            "p.id, p.title, p.imageUrl, p.scrapCount, p.commentCount, p.createdAt, u.nickname, p.x, p.y) " +
            "FROM Post p JOIN p.user u " +
            "WHERE p.recipeId = :recipeId " +
            "ORDER BY p.createdAt DESC")
    List<PostSummary> findPostSummariesByRecipeId(@Param("recipeId") String recipeId);


}
