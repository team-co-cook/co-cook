package com.cocook.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Ingredient extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ingredient_idx")
    private Long id;

    private String ingredientName;

    private String searchKeyword;

//    @OneToMany(mappedBy = "ingredient")
//    private List<Amount> amounts = new ArrayList<>();
}
