package com.cocook.dto.list;

public interface RecipesContainingIngredientsCnt {

    Long getRecipeIdx();

    String getRecipeName();

    String getRecipeImgPath();

    String getRecipeDifficulty();

    Integer getRecipeRunningTime();

    Integer getIsFavorite();

    Integer getTotalIngredientCnt();

    Integer getIncludingIngredientCnt();

}
