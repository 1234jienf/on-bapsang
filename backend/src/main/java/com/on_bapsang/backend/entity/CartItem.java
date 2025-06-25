package com.on_bapsang.backend.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "cart_items")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long cartItemId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)  // FK: userId
    private User user;

    @Column(name = "ingredient_id", nullable = false)
    private Long ingredientId;


    @Column(nullable = false)
    private String ingredientName;

    @Column
    private String category;

    @Column
    private String imageUrl;

    @Column(nullable = false)
    private int price;

    @Column(nullable = false)
    private int quantity;

    public int getTotalPrice() {
        return this.price * this.quantity;
    }
}
