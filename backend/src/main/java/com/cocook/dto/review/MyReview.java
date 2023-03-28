package com.cocook.dto.review;

import java.time.LocalDateTime;

public interface MyReview {

    Long getReviewIdx();

    Long getUserIdx();

    LocalDateTime getCreatedAt();

    String getUserNickname();

    String getContent();

    String getResizedImgPath();

    Integer getLikeCnt();

    Integer getCommentCnt();

    Integer getRunningTime();

    Integer getIsLiked();

    Long getRecipeIdx();

}
