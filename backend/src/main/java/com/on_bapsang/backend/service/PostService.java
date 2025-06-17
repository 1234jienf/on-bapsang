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
        post.setRecipeId(request.getRecipeId());
        post.setImageUrl(imageUrl);
        post.setX(request.getX());
        post.setY(request.getY());
        post.setUser(user);
        return postRepository.save(post);
    }

    public List<RecipeTagSuggestion> getRecipeTagSuggestions(String keyword) {
        return recipeRepository.findTop10ByNameStartingWithIgnoreCase(keyword)
                .stream()
                .map(r -> new RecipeTagSuggestion(r.getRecipeId(), r.getName(), r.getImageUrl()))
                .toList();
    }


    public Page<PostSummaryWithScrap> getPosts(String keyword, Pageable pageable, User user) {
        // 검색어 저장 및 점수 증가
        if (keyword != null && !keyword.isBlank()) {
            searchKeywordService.saveRecentKeyword(user.getUserId(), keyword);
            searchKeywordService.increaseKeywordScore(keyword);
        }

        // keyword와 pageable로 Post + User 조회 (정렬 포함됨)
        Page<Post> postPage = postRepository.findPostsByKeywordWithUser(keyword, pageable);

        // DTO 변환
        List<PostSummaryWithScrap> summaries = postPage.stream()
                .map(post -> {
                    boolean isScrapped = scrapService.isScrapped(post, user);
                    String url = post.getImageUrl() != null
                            ? imageUploader.generatePresignedUrl(post.getImageUrl(), 120)
                            : null;
                    String profileImageUrl = post.getUser().getProfileImage() != null
                            ? imageUploader.generatePresignedUrl(post.getUser().getProfileImage(), 120)
                            : null;

                    return new PostSummaryWithScrap(post, isScrapped, url, profileImageUrl);
                }).toList();

        return new PageImpl<>(summaries, pageable, postPage.getTotalElements());
    }


//    private String getRecipeImageUrl(String recipeId) {
//        if (recipeId == null) return null;
//        return recipeRepository.findById(recipeId)
//                .map(Recipe::getImageUrl)
//                .orElse(null);
//    }

    @Transactional(readOnly = true)
    public PostDetail getPostById(Long id) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 존재하지 않습니다."));

        String postImageUrl = post.getImageUrl() != null
                ? imageUploader.generatePresignedUrl(post.getImageUrl(), 120)
                : null;

        // 레시피 이미지 URL 조회
        String recipeImageUrl = null;
        if (post.getRecipeId() != null) {
            Recipe recipe = recipeRepository.findById(post.getRecipeId()).orElse(null);
            if (recipe != null) {
                recipeImageUrl = recipe.getImageUrl();
            }
        }
        String profileImageUrl = post.getUser().getProfileImage() != null
                ? imageUploader.generatePresignedUrl(post.getUser().getProfileImage(), 120)
                : null;

        return new PostDetail(post, postImageUrl, recipeImageUrl, profileImageUrl);

    }


    @Transactional(readOnly = true)
    public PostDetailWithScrap getPostById(Long id, User user) {
        Post post = postRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 존재하지 않습니다."));

        boolean isScrapped = scrapService.isScrapped(post, user);

        String presignedUrl = post.getImageUrl() != null
                ? imageUploader.generatePresignedUrl(post.getImageUrl(), 120)
                : null;

        // 레시피 이미지 URL 조회
        String recipeImageUrl = null;
        String recipeId = post.getRecipeId();
        System.out.println("DEBUG - recipeId in post: " + recipeId);

        if (recipeId != null) {
            Recipe recipe = recipeRepository.findById(recipeId).orElse(null);
            if (recipe != null) {
                recipeImageUrl = recipe.getImageUrl();
                System.out.println("DEBUG - Found recipe imageUrl: " + recipeImageUrl);
            } else {
                System.out.println("DEBUG - No recipe found with id: " + recipeId);
            }
        } else {
            System.out.println("DEBUG - recipeId is null in Post");
        }

        String profileImageUrl = post.getUser().getProfileImage() != null
                ? imageUploader.generatePresignedUrl(post.getUser().getProfileImage(), 120)
                : null;

        return new PostDetailWithScrap(post, isScrapped, presignedUrl, recipeImageUrl, profileImageUrl);

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
