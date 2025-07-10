package com.on_bapsang.backend.controller;

import com.on_bapsang.backend.dto.IngredientShopResponse;
import com.on_bapsang.backend.security.UserDetailsImpl;
import com.on_bapsang.backend.service.IngredientService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ingredient")
@RequiredArgsConstructor
public class IngredientController {

  private final IngredientService ingredientService;

  @GetMapping("/shop/{ingredient_id}")
  public ResponseEntity<IngredientShopResponse> getIngredientShop(
      @PathVariable("ingredient_id") Long ingredientId,
      @RequestParam(value = "page", defaultValue = "0") int page,
      @RequestParam(value = "size", defaultValue = "10") int size,
      @AuthenticationPrincipal UserDetailsImpl userDetails) {

    IngredientShopResponse response = ingredientService.getIngredientWithRelatedRecipes(
        ingredientId,
        userDetails != null ? userDetails.getUser() : null,
        page,
        size);
    return ResponseEntity.ok(response);
  }
}