package com.cocook.dto.list;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RecipeDetailResDto {

    private Long recipeIdx;

    private String recipeName;

    private String recipeImgPath;

    private String recipeDifficulty;

    private Integer recipeRunningTime;

    private Boolean isFavorite;

}
