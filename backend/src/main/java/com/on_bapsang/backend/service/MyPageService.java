package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.mypage.MyPost;
import com.on_bapsang.backend.dto.mypage.ScrappedPost;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.repository.PostRepository;
import com.on_bapsang.backend.repository.ScrapRepository;
import com.on_bapsang.backend.util.ImageUploader;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import com.on_bapsang.backend.dto.RecipeSummaryDto;
import com.on_bapsang.backend.dto.mypage.ScrappedRecipeResponse;
import com.on_bapsang.backend.entity.RecipeScrap;
import com.on_bapsang.backend.repository.RecipeIngredientRepository;
import com.on_bapsang.backend.repository.RecipeScrapRepository;
import org.springframework.data.domain.PageRequest;



import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MyPageService {

        private final PostRepository postRepository;
        private final ImageUploader imageUploader;
        private final RecipeScrapRepository recipeScrapRepository;
        private final RecipeIngredientRepository recipeIngredientRepository;
        private final ScrapRepository scrapRepository;

        public Page<MyPost> getMyPosts(User user, Pageable pageable) {
                Page<MyPost> page = postRepository.findMyPostsByUser(user.getUserId(), pageable);
                Set<Long> scrappedPostIds = scrapRepository.findScrappedPostIdsByUser(user.getUserId());
                String profileImageUrl = user.getProfileImage() != null
                                ? imageUploader.generatePresignedUrl(user.getProfileImage(), 120)
                                : null;

                List<MyPost> modified = page.getContent().stream().map(post -> {
                        post.setNickname(user.getNickname());
                        post.setProfileImage(profileImageUrl);

                        String imageUrl = post.getImageUrl() != null
                                        ? imageUploader.generatePresignedUrl(post.getImageUrl(), 120)
                                        : null;
                        post.setImageUrl(imageUrl);

                        post.setScrapped(scrappedPostIds.contains(post.getPostId()));

                        return post;
                }).toList();

                return new PageImpl<>(modified, pageable, page.getTotalElements());
        }

        public Page<ScrappedPost> getScrappedPosts(User user, Pageable pageable) {
                Page<ScrappedPost> page = postRepository.findScrappedPostsByUser(user.getUserId(), pageable);

                List<ScrappedPost> modified = page.getContent().stream().map(post -> {
                        // 글 이미지 presigned
                        String postImageUrl = post.getImageUrl() != null
                                        ? imageUploader.generatePresignedUrl(post.getImageUrl(), 120)
                                        : null;
                        post.setImageUrl(postImageUrl);

                        // 작성자 프로필 presigned
                        String profileImageUrl = post.getProfileImage() != null
                                        ? imageUploader.generatePresignedUrl(post.getProfileImage(), 120)
                                        : null;
                        post.setProfileImage(profileImageUrl);
                        post.setScrapped(true);

                        return post;
                }).toList();

                return new PageImpl<>(modified, pageable, page.getTotalElements());
        }

        public ScrappedRecipeResponse getScrappedRecipes(User user, int page, int size) {
                Pageable pageable = PageRequest.of(page, size);
                Page<RecipeScrap> scrapsPage = recipeScrapRepository.findAllWithRecipeByUser(user, pageable);

                List<RecipeSummaryDto> dtos = scrapsPage.stream().map(scrap -> {
                        var recipe = scrap.getRecipe();
                        List<String> ingredientNames = recipeIngredientRepository
                                .findIngredientNamesByRecipeId(recipe.getRecipeId());

                        return new RecipeSummaryDto(
                                recipe.getRecipeId(),
                                recipe.getName(),
                                ingredientNames,
                                recipe.getDescription(),
                                recipe.getReview(),
                                recipe.getTime(),
                                recipe.getDifficulty(),
                                recipe.getPortion(),
                                recipe.getMethod(),
                                recipe.getMaterialType(),
                                recipe.getImageUrl(),
                                true
                        );
                }).toList();

                return new ScrappedRecipeResponse(scrapsPage.getNumber(), scrapsPage.hasNext(), dtos);
        }

}
