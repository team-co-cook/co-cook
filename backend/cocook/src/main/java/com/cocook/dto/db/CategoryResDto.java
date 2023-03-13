package com.cocook.dto.db;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class CategoryResDto {
    private Long categoryId;
    private String categoryName;
}
