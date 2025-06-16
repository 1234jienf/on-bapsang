package com.on_bapsang.backend.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import jakarta.persistence.*;

@Entity
@Table(name = "daily_index")
@Getter
@Setter
@NoArgsConstructor
public class DailyIndex {
    @Id
    private Long id = 1L;

    private Long startRecipeId;  // 오늘 기준 추천 시작 지점
}