package com.cocook.dto.recipe;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
@Builder
public class RecipeDetailResDto {
    List<IngredientDto> ingredients;

    private Integer serving;
    private Integer calorie;

    private Integer carb;

    private Integer protein;

    private Integer fat;
}
