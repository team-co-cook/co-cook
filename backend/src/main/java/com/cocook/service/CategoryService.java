package com.cocook.service;

import com.cocook.dto.db.CategoryReqDto;
import com.cocook.dto.db.CategoryResDto;
import com.cocook.entity.Category;
import com.cocook.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CategoryService {
    private CategoryRepository categoryRepository;

    @Autowired
    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public CategoryResDto makeCategory(CategoryReqDto categoryReqDto) {
        Category category = new Category();
        category.setCategoryName(categoryReqDto.getCategoryName());
        category.setImgPath(categoryReqDto.getCategoryImgPath());
        Category savedCategory = categoryRepository.save(category);
        return new CategoryResDto(savedCategory.getId(), savedCategory.getCategoryName());
    }
}
