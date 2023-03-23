package com.cocook.service;


import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.comment.CommentListResDto;
import com.cocook.dto.comment.CommentResDto;
import com.cocook.entity.Comment;
import com.cocook.entity.Review;
import com.cocook.entity.User;
import com.cocook.repository.CommentRepository;
import com.cocook.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.stereotype.Service;

import javax.persistence.EntityNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CommentService {
    private final CommentRepository commentRepository;
    private final ReviewRepository reviewRepository;
    private final JwtTokenProvider jwtTokenProvider;

    @Autowired
    public CommentService(CommentRepository commentRepository, ReviewRepository reviewRepository,
                          JwtTokenProvider jwtTokenProvider) {
        this.commentRepository = commentRepository;
        this.reviewRepository = reviewRepository;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    public void addComment(Long reviewIdx, String authToken, String content) {
        User user = jwtTokenProvider.getUser(authToken);
        Optional<Review> review = reviewRepository.findById(reviewIdx);
        Comment comment = new Comment();
        comment.setUser(user);
        comment.setReview(review.get());
        comment.setContent(content);
        comment.setReportCnt(0);
        commentRepository.save(comment);
    }

    public void deleteComment(Long commentIdx, String authToken) {
        User user = jwtTokenProvider.getUser(authToken);
        Optional<Comment> comment = commentRepository.findById(commentIdx);
        if (!comment.isPresent()) {
            throw new EntityNotFoundException("해당 댓글이 존재하지 않습니다.");
        }
        if (user == comment.get().getUser()) {
            commentRepository.delete(comment.get());
        } else {
            throw new AuthenticationServiceException(user.getNickname()+"님이 작성한 댓글이 아닙니다.");
        }
    }

    public CommentListResDto getReviewComments(Long reviewIdx) {
        List<Comment> reviewComments = commentRepository.findByReviewId(reviewIdx);
        List<CommentResDto> reviewCommentList = new ArrayList<>();
        for (Comment comment : reviewComments) {
            CommentResDto commentResDto = CommentResDto.builder()
                    .commentIdx(comment.getId())
                    .userIdx(comment.getUser().getId())
                    .userNickname(comment.getUser().getNickname())
                    .reportCnt(comment.getReportCnt())
                    .createdAt(comment.getCreatedDate())
                    .content(comment.getContent())
                    .build();
            reviewCommentList.add(commentResDto);
        }
        return new CommentListResDto(reviewCommentList);
    }
}
