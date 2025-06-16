package com.on_bapsang.backend.entity;

import lombok.*;
import jakarta.persistence.*;

@Entity
@Table(name = "market_price")
@Getter
@Setter
public class MarketPrice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "market_price_id")
    private Long marketPriceId;

    @Column(name = "market_item_id")
    private Integer marketItemId;

    @Column(name = "market_name")
    private String marketName;

    @Column(name = "price_date")
    private String priceDate;  // '20240401' 형태

    @Column(name = "price")
    private Integer price;

    @Column(name = "unit")
    private String unit;

    @Column(name = "grade")
    private String grade;
}
