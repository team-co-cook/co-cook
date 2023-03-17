package com.cocook.repository;

import com.cocook.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Long> {

    Category getCategoryByCategoryName(String categoryName);

}
