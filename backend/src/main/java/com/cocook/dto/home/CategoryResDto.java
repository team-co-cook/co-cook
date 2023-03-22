package com.cocook.dto.home;

import com.cocook.entity.Category;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
@Builder
public class CategoryResDto {

    private Long id;
    private String categoryName;
    private String imgPath;

}
