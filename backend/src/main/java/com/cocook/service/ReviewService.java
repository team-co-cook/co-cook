package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.review.ReviewReqDto;
import com.cocook.dto.review.ReviewResDto;
import com.cocook.entity.Review;
import com.cocook.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final JwtTokenProvider jwtTokenProvider;

    @Autowired
    public ReviewService(ReviewRepository reviewRepository, JwtTokenProvider jwtTokenProvider) {

        this.reviewRepository = reviewRepository;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    public ReviewResDto makeReview(String authToken, ReviewReqDto reviewReqDto) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);
        Review review = new Review();
        review.setContent(reviewReqDto.getContent());
        review.setImgPath(reviewReqDto.getImgPath());
        review.setCommentCnt(0);
        review.setLikeCnt(0);
        review.setReportCnt(0);
        Review newReview = reviewRepository.save(review);
        return new ReviewResDto(newReview.getContent(), newReview.getImgPath(), newReview.getLikeCnt(), newReview.getCommentCnt(), newReview.getRunningTime());
    }
}
