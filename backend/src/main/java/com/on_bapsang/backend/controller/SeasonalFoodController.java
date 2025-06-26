package com.on_bapsang.backend.controller;

import com.on_bapsang.backend.dto.seasonal.SeasonalFoodDto;
import com.on_bapsang.backend.entity.SeasonalFood;
import com.on_bapsang.backend.service.SeasonalFoodService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/seasonal")
public class SeasonalFoodController {

    private final SeasonalFoodService foodService;

    @GetMapping
    public ResponseEntity<List<SeasonalFoodDto>> getByMonth(@RequestParam int month) {
        return ResponseEntity.ok(foodService.getFoodsByMonth(String.valueOf(month)));
    }

    // DB에 직접 저장을 위한 임시 API (초기 데이터 저장용)
    @PostMapping("/import")
    public ResponseEntity<?> importFoods(@RequestParam int month) {
        foodService.fetchAndSaveFoods(month);
        return ResponseEntity.ok("저장 완료");
    }
}
