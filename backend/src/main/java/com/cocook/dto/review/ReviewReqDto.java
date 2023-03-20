package com.cocook.dto.review;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReviewReqDto {
    @NotBlank(message = "내용을 입력하세요")
    private String content;

    private Long recipeIdx;
    private Integer runningTime;
}
