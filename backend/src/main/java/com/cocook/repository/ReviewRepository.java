package com.cocook.repository;

import com.cocook.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findReviewsByRecipeIdOrderByReviewIdDesc(Long recipeIdx);
}
