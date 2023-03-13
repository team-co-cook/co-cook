package com.cocook.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Amount {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "amount_idx")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "recipe_idx")
    private Recipe recipe;

    @ManyToOne
    @JoinColumn(name = "ingredient_idx")
    private Ingredient ingredient;

    private String content;
}
