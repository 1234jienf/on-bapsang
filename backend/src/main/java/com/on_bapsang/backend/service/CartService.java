package com.on_bapsang.backend.service;

import com.on_bapsang.backend.dto.CartItemRequest;
import com.on_bapsang.backend.dto.CartItemResponse;
import com.on_bapsang.backend.dto.IngredientInfo;
import com.on_bapsang.backend.entity.CartItem;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.repository.CartItemRepository;
import com.on_bapsang.backend.config.IngredientDataLoader;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CartService {

    private final CartItemRepository cartItemRepository;
    private final IngredientDataLoader ingredientDataLoader;

    public List<CartItemResponse> addItems(User user, List<CartItemRequest> requests) {
        List<CartItemResponse> result = new ArrayList<>();
        for (CartItemRequest req : requests) {
            IngredientInfo info = ingredientDataLoader.getInfo(req.getIngredientId());
            if (info == null)
                throw new RuntimeException("재료 정보를 찾을 수 없습니다: " + req.getIngredientId());

            // 이미 장바구니에 같은 재료가 있는지 확인
            CartItem existingItem = cartItemRepository.findByUserAndIngredientId(user, req.getIngredientId())
                    .orElse(null);

            if (existingItem != null) {
                // 기존 아이템의 수량 증가
                existingItem.setQuantity(existingItem.getQuantity() + req.getQuantity());
                cartItemRepository.save(existingItem);
                result.add(toResponse(existingItem));
            } else {
                // 새로운 아이템 추가
                CartItem item = CartItem.builder()
                        .user(user)
                        .ingredientId(info.getIngredientId())
                        .ingredientName(info.getIngredientName())
                        .category(info.getCategory())
                        .imageUrl(info.getImageUrl())
                        .price(info.getSalePrice()) // cart에는 할인가만 저장
                        .quantity(req.getQuantity())
                        .build();

                cartItemRepository.save(item);
                result.add(toResponse(item));
            }
        }
        return result;
    }

    public List<CartItemResponse> getCartItems(User user) {
        return cartItemRepository.findByUser(user).stream()
                .map(this::toResponse)
                .toList();
    }

    public CartItemResponse updateQuantity(Long cartItemId, int quantity) {
        CartItem item = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("장바구니 항목을 찾을 수 없습니다."));
        item.setQuantity(quantity);
        cartItemRepository.save(item);
        return toResponse(item);
    }

    public void deleteItem(Long cartItemId) {
        cartItemRepository.deleteById(cartItemId);
    }

    private CartItemResponse toResponse(CartItem item) {
        return new CartItemResponse(
                item.getCartItemId(),
                item.getIngredientId(),
                item.getIngredientName(),
                item.getCategory(),
                item.getImageUrl(),
                item.getPrice(),
                item.getQuantity(),
                item.getTotalPrice());
    }
}
