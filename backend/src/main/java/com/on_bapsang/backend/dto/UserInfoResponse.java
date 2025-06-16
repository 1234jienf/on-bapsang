package com.on_bapsang.backend.dto;

import com.on_bapsang.backend.entity.*;
import lombok.Getter;

import java.util.List;
import java.util.stream.Collectors;

@Getter
public class UserInfoResponse {
    private Long userId;
    private String username;
    private String nickname;
    private String country;
    private Integer age;
    private String location;
    private String profileImage;

    private List<String> favoriteTastes;
    private List<String> favoriteDishes;
    private List<String> favoriteIngredients;

    public UserInfoResponse(User user, String profileImagePresignedUrl) {
        this.userId = user.getUserId();
        this.username = user.getUsername();
        this.nickname = user.getNickname();
        this.country = user.getCountry();
        this.age = user.getAge();
        this.location = user.getLocation();
        this.profileImage = profileImagePresignedUrl;

        this.favoriteTastes = user.getFavoriteTastes().stream()
                .map(userTaste -> userTaste.getTaste().getName())
                .collect(Collectors.toList());

        this.favoriteDishes = user.getFavoriteDishes().stream()
                .map(userDish -> userDish.getDish().getName())
                .collect(Collectors.toList());

        this.favoriteIngredients = user.getFavoriteIngredients().stream()
                .map(userIngredient -> userIngredient.getIngredient().getName())
                .collect(Collectors.toList());
    }
}
