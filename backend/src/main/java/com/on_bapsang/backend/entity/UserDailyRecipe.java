package com.on_bapsang.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "date"}))
public class UserDailyRecipe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    private User user;

    private LocalDate date;

    @ElementCollection
    @CollectionTable(name = "user_daily_recipe_ids", joinColumns = @JoinColumn(name = "user_daily_recipe_id"))
    @Column(name = "recipe_id")
    private List<String> recipeIds;
}
