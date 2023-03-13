package com.cocook.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Tag {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "tag_idx")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "recipe_idx")
    private Recipe recipe;

    @ManyToOne
    @JoinColumn(name = "theme_idx")
    private Theme theme;
}
