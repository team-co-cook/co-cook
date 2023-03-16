package com.cocook.dto.recipe;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RecipeListResDto {

    private Long recipeIdx;

    private String recipeName;

    private String recipeImgPath;

    private String recipeDifficulty;

    private Integer recipeRunningTime;

    private Boolean isFavorite;

}
