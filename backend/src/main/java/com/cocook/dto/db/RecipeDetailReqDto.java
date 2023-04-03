package com.cocook.dto.db;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeDetailReqDto {
    private String recipeName;
    private String difficulty;
    private Integer runningTime;
    private Integer calorie;
    private Integer serving;
    private Integer carb;
    private Integer protein;
    private Integer fat;

}
