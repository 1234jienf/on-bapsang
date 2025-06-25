package com.on_bapsang.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CartItemResponse {
    private Long cartItemId;
    private Long ingredientId;
    private String ingredientName;
    private String category;
    private String imageUrl;
    private int price;
    private int quantity;
    private int totalPrice;
}
