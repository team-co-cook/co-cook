package com.cocook.dto.review;

import lombok.AllArgsConstructor;
import lombok.Data;

import javax.validation.constraints.NotBlank;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class ReviewResDto {
    private Long reviewIdx;
    private Long userIdx;
    private LocalDateTime createdAt;

    private String userNickname;

    private String content;

    private String imgPath;


    private Integer likeCnt;

    private Integer commentCnt;

    private Integer runningTime;

    private boolean isLiked;
}
