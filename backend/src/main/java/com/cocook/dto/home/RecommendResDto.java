package com.cocook.dto.home;

import com.cocook.dto.recipe.RecipeListResDto;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Data
@AllArgsConstructor
public class RecommendResDto {

    private String currentTime;

    private List<RecipeListResDto> recipes;

}
