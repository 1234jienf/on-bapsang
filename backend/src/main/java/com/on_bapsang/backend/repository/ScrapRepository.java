package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.Post;
import com.on_bapsang.backend.entity.Scrap;
import com.on_bapsang.backend.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.List;

public interface ScrapRepository extends JpaRepository<Scrap, Long> {
    Optional<Scrap> findByUserAndPost(User user, Post post);
    List<Scrap> findAllByUser(User user);
    void deleteByUserAndPost(User user, Post post);
    @Query("SELECT CASE WHEN COUNT(s) > 0 THEN true ELSE false END FROM Scrap s WHERE s.user.userId = :userId AND s.post.id = :postId")
    boolean existsByUserIdAndPostId(@Param("userId") Long userId, @Param("postId") Long postId);

}

