package com.cocook.entity;

import com.sun.istack.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@NoArgsConstructor
public class Theme extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "theme_idx")
    private Long id;

    @NotNull
    private String themeName;

    @NotNull
    private String imgPath;

//    @OneToMany(mappedBy = "theme")
//    private List<Tag> tags = new ArrayList<>();
}
