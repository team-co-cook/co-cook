package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.review.ReviewReqDto;
import com.cocook.dto.review.ReviewResDto;
import com.cocook.entity.Recipe;
import com.cocook.entity.Review;
import com.cocook.entity.User;
import com.cocook.repository.RecipeRepository;
import com.cocook.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final JwtTokenProvider jwtTokenProvider;
    private final RecipeRepository recipeRepository;

    @Autowired
    public ReviewService(ReviewRepository reviewRepository, JwtTokenProvider jwtTokenProvider, RecipeRepository recipeRepository) {

        this.reviewRepository = reviewRepository;
        this.jwtTokenProvider = jwtTokenProvider;
        this.recipeRepository = recipeRepository;
    }

    public ReviewResDto makeReview(String authToken, ReviewReqDto reviewReqDto) {
        User user = jwtTokenProvider.getUser(authToken);
        Recipe recipe = recipeRepository.findRecipeById(reviewReqDto.getRecipeIdx());
        Review review = new Review();
        review.setContent(reviewReqDto.getContent());
        review.setImgPath(reviewReqDto.getImgPath());
        review.setCommentCnt(0);
        review.setLikeCnt(0);
        review.setRunningTime(reviewReqDto.getRunningTime());
        review.setReportCnt(0);
        review.setUser(user);
        review.setRecipe(recipe);
        Review newReview = reviewRepository.save(review);
        return new ReviewResDto(newReview.getContent(), newReview.getImgPath(), newReview.getLikeCnt(), newReview.getCommentCnt(), newReview.getRunningTime());
    }
}
