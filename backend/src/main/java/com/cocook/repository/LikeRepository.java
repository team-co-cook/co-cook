package com.cocook.repository;

import com.cocook.entity.LikeReview;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LikeRepository extends JpaRepository<LikeReview, Long> {
    LikeReview findByUserIdAndReviewId(Long userId, Long reviewId);
}
