package com.cocook.dto.review;

import lombok.AllArgsConstructor;
import lombok.Data;

import javax.validation.constraints.NotBlank;

@Data
@AllArgsConstructor
public class ReviewResDto {
    private Long reviewIdx;

    private String userNickname;

    private String content;

    private String imgPath;

    private Integer likeCnt;

    private Integer commentCnt;

    private Integer runningTime;


}
