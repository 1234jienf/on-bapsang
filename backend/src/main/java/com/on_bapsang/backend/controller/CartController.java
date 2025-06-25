package com.on_bapsang.backend.controller;

import com.on_bapsang.backend.dto.CartItemRequest;
import com.on_bapsang.backend.dto.CartItemResponse;
import com.on_bapsang.backend.entity.User;
import com.on_bapsang.backend.security.UserDetailsImpl;
import com.on_bapsang.backend.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/cart")
public class CartController {

    private final CartService cartService;

    @GetMapping
    public ResponseEntity<?> getCartItems(@AuthenticationPrincipal UserDetailsImpl userDetails) {
        User user = userDetails.getUser();
        List<CartItemResponse> items = cartService.getCartItems(user);
        int total = items.stream().mapToInt(CartItemResponse::getTotalPrice).sum();
        return ResponseEntity.ok(Map.of("items", items, "total_price", total));
    }

    @PostMapping
    public ResponseEntity<?> addToCart(@AuthenticationPrincipal UserDetailsImpl userDetails,
            @RequestBody Map<String, List<CartItemRequest>> body) {
        User user = userDetails.getUser();
        List<CartItemRequest> items = body.get("items");
        List<CartItemResponse> added = cartService.addItems(user, items);
        return ResponseEntity.ok(Map.of(
                "message", added.size() + "개 항목이 장바구니에 추가되었습니다.",
                "added_items", added));
    }

    @PatchMapping("/{cartItemId}")
    public ResponseEntity<?> updateQuantity(@PathVariable Long cartItemId,
            @RequestBody Map<String, Integer> body) {
        int quantity = body.get("quantity");
        CartItemResponse updated = cartService.updateQuantity(cartItemId, quantity);
        return ResponseEntity.ok(Map.of(
                "message", "장바구니 수량이 수정되었습니다.",
                "updated_quantity", updated.getQuantity()));
    }

    @DeleteMapping("/{cartItemId}")
    public ResponseEntity<?> deleteItem(@PathVariable Long cartItemId) {
        cartService.deleteItem(cartItemId);
        return ResponseEntity.ok(Map.of(
                "message", "장바구니 항목이 삭제되었습니다.",
                "cart_item_id", cartItemId));
    }
}
