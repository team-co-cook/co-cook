package com.cocook.dto.recipe;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RecipeStepDetailResDto {

    private String imgPath;

    private Integer timer;

    private String content;

    private Integer currentStep;

}
