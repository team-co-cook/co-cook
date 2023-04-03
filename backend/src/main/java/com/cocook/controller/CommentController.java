package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.dto.comment.CommentListResDto;
import com.cocook.dto.comment.CommentReqDto;
import com.cocook.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/v1/comment")
public class CommentController {
    private final CommentService commentService;
    @Autowired
    public CommentController(CommentService commentService) {
        this.commentService = commentService;
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Object>> addComment(@RequestHeader("AUTH-TOKEN") String authToken, @Valid @RequestBody CommentReqDto commentReqDto) {
        Long reviewIdx = commentReqDto.getReviewIdx();
        String content = commentReqDto.getContent();
        commentService.addComment(reviewIdx, authToken, content);
        return ApiResponse.ok(null);
    }

    @DeleteMapping("/{comment_idx}")
    public ResponseEntity<ApiResponse<Object>> deleteComment(@RequestHeader("AUTH-TOKEN") String authToken, @PathVariable("comment_idx") Long commentIdx) {
        commentService.deleteComment(commentIdx, authToken);
        return ApiResponse.ok(null);
    }

    @GetMapping("/{review_idx}")
    public ResponseEntity<ApiResponse<CommentListResDto>> getReviewComments(@RequestHeader("AUTH-TOKEN") String authToken, @PathVariable("review_idx") Long reviewIdx) {
        return ApiResponse.ok(commentService.getReviewComments(reviewIdx));
    }
}
