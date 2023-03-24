package com.cocook.dto.review;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class MyReviewResDto {

    private Long reviewIdx;

    private Long userIdx;

    private LocalDateTime createdAt;

    private String userNickname;

    private String content;

    private String imgPath;

    private Integer likeCnt;

    private Integer commentCnt;

    private Integer runningTime;

    private Boolean isLiked;

    private Long recipeIdx;

}
