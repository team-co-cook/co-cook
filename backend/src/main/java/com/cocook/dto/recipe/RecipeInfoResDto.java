package com.cocook.dto.recipe;

import com.cocook.dto.list.RecipeDetailResDto;
import com.cocook.entity.Ingredient;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class RecipeInfoResDto {

    private String recipeName;

    private String recipeImgPath;

    private String recipeDifficulty;

    private Integer recipeRunningTime;

    private Boolean isFavorite;
    List<Ingredient> ingredients;

    private Integer serving;
    private Integer calorie;

    private Integer carb;

    private Integer protein;

    private Integer fat;
}
