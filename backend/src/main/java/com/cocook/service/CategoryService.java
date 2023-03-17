package com.cocook.service;

import com.cocook.dto.db.CategoryResDto;
import com.cocook.entity.Category;
import com.cocook.repository.CategoryRepository;
import com.cocook.util.S3Uploader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class CategoryService {
    private final CategoryRepository categoryRepository;
    private final S3Uploader s3Uploader;

    @Autowired
    public CategoryService(CategoryRepository categoryRepository, S3Uploader s3Uploader) {
        this.categoryRepository = categoryRepository;
        this.s3Uploader = s3Uploader;
    }

    public CategoryResDto makeCategory(String categoryName, MultipartFile categoryImg) {

        String storedFilePath;
        try {
            storedFilePath = s3Uploader.upload(categoryImg,"images");
        } catch (IOException e) {
            throw new RuntimeException(e.getMessage());
        }

        Category category = new Category();
        category.setCategoryName(categoryName);
        category.setImgPath(storedFilePath);
        Category savedCategory = categoryRepository.save(category);
        return new CategoryResDto(savedCategory.getId(), savedCategory.getCategoryName());
    }
}
