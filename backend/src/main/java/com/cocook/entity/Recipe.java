package com.cocook.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Recipe extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "recipe_idx")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_idx")
    private Category category;

    private String recipeName;

    private String difficulty;

    private Integer runningTime;

    private Integer serving;

    private String imgPath;

    private Integer calorie;

    private Integer carb;

    private Integer protein;

    private Integer fat;

    //    @OneToMany(mappedBy = "recipe")
//    private List<Step> steps = new ArrayList<>();
//
//    @OneToMany(mappedBy = "recipe")
//    private List<Amount> amounts = new ArrayList<>();
//
    @OneToMany(mappedBy = "recipe", fetch = FetchType.LAZY)
    private List<Review> reviews = new ArrayList<>();

    @OneToMany(mappedBy = "recipe", fetch = FetchType.LAZY)
    private List<Tag> tags = new ArrayList<>();

    @OneToMany(mappedBy = "recipe", fetch = FetchType.LAZY)
    private List<Favorite> favorites = new ArrayList<>();

}
