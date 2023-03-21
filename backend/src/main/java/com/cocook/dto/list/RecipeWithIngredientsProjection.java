package com.cocook.dto.list;

public interface RecipeWithIngredientsProjection {

    Long getRecipeIdx();

    String getRecipeName();

    String getRecipeImgPath();

    String getRecipeDifficulty();

    Integer getRecipeRunningTime();

    Integer getIsFavorite();

    Integer getTotalIngredientCnt();

    Integer getIncludingIngredientCnt();

}
