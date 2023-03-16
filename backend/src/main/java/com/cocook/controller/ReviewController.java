package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.dto.review.ReviewReqDto;
import com.cocook.dto.review.ReviewResDto;
import com.cocook.service.ReviewService;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("api/v1/review")
public class ReviewController {

    private final ReviewService reviewService;

    @Autowired
    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @PostMapping("/")
    public ResponseEntity<ApiResponse<ReviewResDto>> makeReview(@RequestHeader("AUTH-TOKEN") String authToken, @Valid @RequestBody ReviewReqDto reviewReqDto) {
        ReviewResDto reviewResDto = reviewService.makeReview(authToken, reviewReqDto);
        return ApiResponse.ok(reviewResDto);
    }
}
