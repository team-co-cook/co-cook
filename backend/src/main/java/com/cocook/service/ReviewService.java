package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.review.ReviewReqDto;
import com.cocook.dto.review.ReviewResDto;
import com.cocook.entity.Recipe;
import com.cocook.entity.Review;
import com.cocook.entity.User;
import com.cocook.repository.RecipeRepository;
import com.cocook.repository.ReviewRepository;
import com.cocook.util.S3Uploader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final JwtTokenProvider jwtTokenProvider;
    private final RecipeRepository recipeRepository;
    private final S3Uploader s3Uploader;

    @Autowired
    public ReviewService(ReviewRepository reviewRepository, JwtTokenProvider jwtTokenProvider, RecipeRepository recipeRepository, S3Uploader s3Uploader) {

        this.jwtTokenProvider = jwtTokenProvider;
        this.reviewRepository = reviewRepository;
        this.recipeRepository = recipeRepository;
        this.s3Uploader = s3Uploader;
    }



    public ReviewResDto makeReview(String authToken, ReviewReqDto reviewReqDto, MultipartFile reviewImg) {
        User user = jwtTokenProvider.getUser(authToken);
        Recipe recipe = recipeRepository.findRecipeById(reviewReqDto.getRecipeIdx());
        Review review = new Review();
        review.setContent(reviewReqDto.getContent());
        try {
            String storedFilePath = s3Uploader.upload(reviewImg,"images");
            review.setImgPath(storedFilePath);
        } catch (IOException e) {
            throw new RuntimeException(e.getMessage());
        }
        review.setCommentCnt(0);
        review.setLikeCnt(0);
        review.setRunningTime(reviewReqDto.getRunningTime());
        review.setReportCnt(0);
        review.setUser(user);
        review.setRecipe(recipe);
        Review newReview = reviewRepository.save(review);
        return new ReviewResDto(newReview.getId(), newReview.getCreatedDate(), user.getNickname(), newReview.getContent(), newReview.getImgPath(), newReview.getLikeCnt(), newReview.getCommentCnt(), newReview.getRunningTime());
    }
}
