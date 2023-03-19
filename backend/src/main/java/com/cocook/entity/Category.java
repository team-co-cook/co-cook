package com.cocook.entity;

import com.sun.istack.NotNull;
import lombok.*;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Category extends BaseEntity {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_idx")
    private Long id;

    @NotNull
    private String categoryName;

    @NotNull
    private String imgPath;

//    @OneToMany(mappedBy = "category", fetch = FetchType.LAZY)
//    private List<Recipe> recipeList = new ArrayList<>();
}
