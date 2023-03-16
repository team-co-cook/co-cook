package com.cocook.dto.home;

import com.cocook.entity.Category;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class CategoryResDto {

    List<Category> categories;

}
