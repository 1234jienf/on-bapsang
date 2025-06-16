package com.on_bapsang.backend.entity;

import lombok.*;
import jakarta.persistence.*;

@Entity
@Table(name = "market_item")
@Getter
@Setter
public class MarketItem {

    @Id
    @Column(name = "market_item_id")
    private Integer marketItemId;

    @Column(name = "pdl_nm")
    private String pdlName;

    @Column(name = "product_name")
    private String productName;

    @Column(name = "spcs_nm")
    private String spcsName;

    @Column(name = "detail")
    private String detail;
}
