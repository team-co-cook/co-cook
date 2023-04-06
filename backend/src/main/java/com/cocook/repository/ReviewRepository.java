package com.cocook.repository;

import com.cocook.dto.review.MyReview;
import com.cocook.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findReviewsByRecipeIdOrderByIdDesc(Long recipeIdx);

    @Query(value = "SELECT review_idx AS reviewIdx, comment_cnt AS commentCnt, content, img_path AS imgPath, like_cnt AS likeCnt, " +
            "report_cnt AS reportCnt, running_time AS runningTime, recipe_idx AS recipeIdx, user_idx AS userIdx, created_date AS createdAt, " +
            "(SELECT nickname FROM user WHERE user.user_idx = :userIdx) AS userNickname, " +
            "EXISTS (SELECT 1 FROM like_review lr WHERE lr.user_idx = :userIdx AND lr.review_idx = r.review_idx) AS isLiked " +
            "FROM review r WHERE r.user_idx = :userIdx ORDER BY review_idx DESC;", nativeQuery = true)
    List<MyReview> findReviewsByUserIdOrderByIdDesc(@Param("userIdx") Long userIdx);
}
