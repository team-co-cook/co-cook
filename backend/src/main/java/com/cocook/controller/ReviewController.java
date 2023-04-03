package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.dto.review.ReviewReqDto;
import com.cocook.dto.review.ReviewResDto;
import com.cocook.service.ReviewService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.IOException;

@RestController
@RequestMapping("/api/v1/review")
public class ReviewController {

    private final ReviewService reviewService;
    private final ObjectMapper objectMapper;

    @Autowired
    public ReviewController(ReviewService reviewService, ObjectMapper objectMapper) {
        this.reviewService = reviewService;
        this.objectMapper = objectMapper;
    }

    @PostMapping(value = "", consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<ApiResponse<String>> makeReview(@RequestHeader("AUTH-TOKEN") String authToken,
                                                                @RequestParam("reviewDetail") String reviewDetail,
                                                                @RequestPart("reviewImg") MultipartFile reviewImg) {
        try {
            ReviewReqDto reviewReqDto = objectMapper.readValue(reviewDetail, ReviewReqDto.class);
            reviewService.makeReview(authToken, reviewReqDto, reviewImg);
            return ApiResponse.ok("OK");
        } catch (IOException e) {
            throw new RuntimeException("유효하지 않습니다.");
        }
    }

    @DeleteMapping(value = "/{review_idx}")
    public ResponseEntity<ApiResponse<Object>> deleteReview(@RequestHeader("AUTH-TOKEN") String authToken,
                                                    @PathVariable("review_idx") Long reviewIdx) {
        reviewService.deleteReview(reviewIdx, authToken);
        return ApiResponse.ok(null);
    }

    @PostMapping(value = "/like/{review_idx}")
    public ResponseEntity<ApiResponse<Object>> likeReview(@RequestHeader("AUTH-TOKEN") String authToken,
                                                          @PathVariable("review_idx") Long reviewIdx) {
        reviewService.addLike(reviewIdx, authToken);
        return ApiResponse.ok(null);
    }

    @DeleteMapping(value = "/like/{review_idx}")
    public ResponseEntity<ApiResponse<Object>> deleteLike(@RequestHeader("AUTH-TOKEN") String authToken,
                                                            @PathVariable("review_idx") Long reviewIdx) {
        reviewService.deleteLike(reviewIdx, authToken);
        return ApiResponse.ok(null);
    }
}
