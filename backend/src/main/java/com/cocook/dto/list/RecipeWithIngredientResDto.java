package com.cocook.dto.list;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeWithIngredientResDto {

    private Long recipeIdx;

    private String recipeName;

    private String recipeImgPath;

    private String recipeDifficulty;

    private Integer recipeRunningTime;

    private Integer isFavorite;

    private Integer totalIngredientCnt;

    private Integer includingIngredientCnt;

}
