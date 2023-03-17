package com.cocook.dto.db;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.lang.Nullable;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class StepReqDto {
    private String content;
    private Integer timer;
    private Integer currentStep;
}
