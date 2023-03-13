package com.cocook.dto.db;

import lombok.Data;

@Data
public class RecipeDetailReqDto {
    private String recipeName;
    private String imgPath;
    private Integer difficulty;
    private Integer runningTime;
    private Integer calorie;
    private Integer serving;
    private Integer carb;
    private Integer protein;
    private Integer fat;

}
