package com.cocook.dto.home;

import com.cocook.dto.recipe.RecipeListResDto;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class RandomResDto {

    private List<RecipeListResDto> recipes;

}
