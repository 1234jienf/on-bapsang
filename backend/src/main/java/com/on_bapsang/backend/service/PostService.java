package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.*;
import com.on_bapsang.backend.entity.Post;
import com.on_bapsang.backend.entity.Recipe;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.repository.PostRepository;
import com.on_bapsang.backend.repository.RecipeRepository;
import com.on_bapsang.backend.service.ScrapService;
import com.on_bapsang.backend.service.SearchKeywordService;
import com.on_bapsang.backend.util.ImageUploader;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostRepository postRepository;
    private final RecipeRepository recipeRepository;
    private final ScrapService scrapService;
    private final SearchKeywordService searchKeywordService;
    private final ImageUploader imageUploader;

    public Post create(PostRequest request, User user, String imageUrl) {
        Post post = new Post();
        post.setTitle(request.getTitle());
        post.setContent(request.getContent());
        post.setRecipeTag(request.getRecipeTag());
        post.setImageUrl(imageUrl);
        post.setX(request.getX());
        post.setY(request.getY());
        post.setUser(user);
        return postRepository.save(post);
    }

    public List<String> getRecipeTagSuggestions(String keyword) {
        return recipeRepository.findTop10ByNameStartingWithIgnoreCase(keyword)
                .stream()
                .map(Recipe::getName)
                .toList();
    }

    public Page<PostSummaryWithScrap> getPosts(String keyword, Pageable pageable, User user) {
        Page<Long> postIdPage;
        List<Post> posts;

        if (keyword != null && !keyword.isBlank()) {
            searchKeywordService.saveRecentKeyword(user.getUserId(), keyword);
            searchKeywordService.increaseKeywordScore(keyword);

            // 🔍 검색어 기반 ID 페이징
            postIdPage = postRepository.findPostIdsByTitleKeyword(keyword, pageable);
        } else {
            // 🔍 전체 글 ID 페이징
            postIdPage = postRepository.findAllPostIds(pageable);
        }

        // ✅ ID 리스트로 Post + User fetch join 조회
        posts = postRepository.findAllWithUserByIds(postIdPage.getContent());

        List<PostSummaryWithScrap> summaries = posts.stream()
                .map(post -> {
                    boolean isScrapped = scrapService.isScrapped(post, user);
                    String url = post.getImageUrl() != null
                            ? imageUploader.generatePresignedUrl(post.getImageUrl(), 60)
                            : null;
                    return new PostSummaryWithScrap(post, isScrapped, url);
                }).toList();

        return new PageImpl<>(summaries, pageable, postIdPage.getTotalElements());
    }

    @Transactional(readOnly = true)
    public PostDetail getPostById(Long id) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 존재하지 않습니다."));
        String presignedUrl = post.getImageUrl() != null
                ? imageUploader.generatePresignedUrl(post.getImageUrl(), 10)
                : null;
        return new PostDetail(post, presignedUrl);
    }

    @Transactional(readOnly = true)
    public PostDetailWithScrap getPostById(Long id, User user) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 존재하지 않습니다."));
        boolean isScrapped = scrapService.isScrapped(post, user);
        String presignedUrl = post.getImageUrl() != null
                ? imageUploader.generatePresignedUrl(post.getImageUrl(), 10)
                : null;
        return new PostDetailWithScrap(post, isScrapped, presignedUrl);
    }

    public Post update(Long id, PostRequest request, User user, String imageUrl) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("게시글이 존재하지 않습니다."));

        if (!post.getUser().getUserId().equals(user.getUserId())) {
            throw new IllegalArgumentException("작성자만 수정할 수 있습니다.");
        }

        post.setTitle(request.getTitle());
        post.setContent(request.getContent());
        post.setRecipeTag(request.getRecipeTag());
        post.setX(request.getX());
        post.setY(request.getY());

        if (imageUrl != null) {
            post.setImageUrl(imageUrl);
        }

        return postRepository.save(post);
    }

    public void delete(Long id, User user) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("게시글이 존재하지 않습니다."));

        if (!post.getUser().getUserId().equals(user.getUserId())) {
            throw new IllegalArgumentException("작성자만 삭제할 수 있습니다.");
        }

        postRepository.delete(post);
    }
}
