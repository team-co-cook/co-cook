package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.review.ReviewReqDto;
import com.cocook.entity.LikeReview;
import com.cocook.entity.Recipe;
import com.cocook.entity.Review;
import com.cocook.entity.User;
import com.cocook.repository.LikeRepository;
import com.cocook.repository.RecipeRepository;
import com.cocook.repository.ReviewRepository;
import com.cocook.util.S3Uploader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.persistence.EntityNotFoundException;
import java.io.IOException;
import java.util.Optional;

@Service
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final JwtTokenProvider jwtTokenProvider;
    private final RecipeRepository recipeRepository;
    private final S3Uploader s3Uploader;
    private final LikeRepository likeRepository;

    @Autowired
    public ReviewService(ReviewRepository reviewRepository, JwtTokenProvider jwtTokenProvider, RecipeRepository recipeRepository,
                         S3Uploader s3Uploader, LikeRepository likeRepository) {

        this.jwtTokenProvider = jwtTokenProvider;
        this.reviewRepository = reviewRepository;
        this.recipeRepository = recipeRepository;
        this.s3Uploader = s3Uploader;
        this.likeRepository = likeRepository;
    }



    public void makeReview(String authToken, ReviewReqDto reviewReqDto, MultipartFile reviewImg) {
        User user = jwtTokenProvider.getUser(authToken);
        Recipe recipe = recipeRepository.findRecipeById(reviewReqDto.getRecipeIdx());
        Review review = new Review();
        review.setContent(reviewReqDto.getContent());
        try {
//            review.setResizedImgPath(s3Uploader.uploadResizedImage(reviewImg,"images"));
            review.setImgPath(s3Uploader.upload(reviewImg, "images"));
        } catch (IOException e) {
            System.out.println(e.getMessage());
        } finally {
            review.setCommentCnt(0);
            review.setLikeCnt(0);
            review.setRunningTime(reviewReqDto.getRunningTime());
            review.setReportCnt(0);
            review.setUser(user);
            review.setRecipe(recipe);
            reviewRepository.save(review);
        }
    }

    public void deleteReview(Long reviewIdx, String authToken) {
        Optional<Review> review = reviewRepository.findById(reviewIdx);
        User user = jwtTokenProvider.getUser(authToken);
        if (review.isPresent()) {
            if (review.get().getUser() == user) {
                reviewRepository.delete(review.get());
            } else {
                throw new AuthenticationServiceException(user.getNickname()+"님이 작성한 리뷰가 아닙니다.");
            }
        } else {
            throw new EntityNotFoundException("해당 리뷰가 존재하지 않습니다.");
        }
    }

    public void addLike(Long reviewIdx, String authToken) {
        User user = jwtTokenProvider.getUser(authToken);
        Optional<Review> review = reviewRepository.findById(reviewIdx);
        if (review.isEmpty()) {
            throw new EntityNotFoundException("해당 리뷰가 존재하지 않습니다.");
        }
        LikeReview likeReview = likeRepository.findByUserIdAndReviewId(user.getId(), reviewIdx);
        if (likeReview != null) {
            throw new EntityNotFoundException("이미 좋아요 했습니다.");
        } else {
            LikeReview newLikeReview = new LikeReview();
            newLikeReview.setUser(user);
            newLikeReview.setReview(review.get());
            likeRepository.save(newLikeReview);

            review.get().setLikeCnt(review.get().getLikeCnt()+1);
            reviewRepository.save(review.get());
        }
    }

    public void deleteLike(Long reviewIdx, String authToken) {
        User user = jwtTokenProvider.getUser(authToken);
        Optional<Review> review = reviewRepository.findById(reviewIdx);
        if (review.isEmpty()) {
            throw new EntityNotFoundException("해당 리뷰가 존재하지 않습니다.");
        }
        LikeReview likeReview = likeRepository.findByUserIdAndReviewId(user.getId(), reviewIdx);
        if (likeReview != null) {
            likeRepository.delete(likeReview);

            review.get().setLikeCnt(review.get().getLikeCnt()-1);
            reviewRepository.save(review.get());
        } else {
            throw new EntityNotFoundException("좋아하지 않는 리뷰입니다.");
        }
    }
}
