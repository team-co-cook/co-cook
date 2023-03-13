package com.cocook.dto.db;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RecipeReqDto {
    private RecipeDetailReqDto recipe;
    private List<StepReqDto> steps;
    private List<IngredientReqDto> ingredient;
    private String category;
    private List<String> themes;

}
