package com.cocook.dto.db;

import lombok.Data;

@Data
public class StepReqDto {
    private String content;
    private String imgPath;
    private Integer timer;
    private Integer currentStep;
}
