package com.on_bapsang.backend.repository;

import com.on_bapsang.backend.entity.DailyIndex;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DailyIndexRepository extends JpaRepository<DailyIndex, Long> {
}