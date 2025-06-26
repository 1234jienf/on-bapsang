package com.on_bapsang.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SafeRestaurantResponse {
  private Integer totalCnt;
  private List<SafeRestaurantRow> rows;
}