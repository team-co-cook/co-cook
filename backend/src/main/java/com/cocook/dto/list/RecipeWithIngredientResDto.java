package com.cocook.dto.list;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RecipeWithIngredientResDto {

    private Long recipeIdx;

    private String recipeName;

    private String recipeImgPath;

    private String recipeDifficulty;

    private Integer recipeRunningTime;

    private Boolean isFavorite;

    private Integer totalIngredientCnt;

    private Integer includingIngredientCnt;

}
