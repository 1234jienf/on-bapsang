package com.on_bapsang.backend.controller;

import com.on_bapsang.backend.dto.SafeRestaurantResponse;
import com.on_bapsang.backend.service.SafeRestaurantDomService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/safe-restaurants")
public class SafeRestaurantController {

    private final SafeRestaurantDomService service;

    // GET /api/safe-restaurants?city=경상북도&gu=포항시&start=1&end=100
    @GetMapping
    public SafeRestaurantResponse list(
            @RequestParam String city,
            @RequestParam String gu,
            @RequestParam(defaultValue = "1") int start,
            @RequestParam(defaultValue = "100") int end) throws Exception {

        return service.fetch(city, gu, start, end);
    }
}
