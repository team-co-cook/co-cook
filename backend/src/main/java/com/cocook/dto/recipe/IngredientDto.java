package com.cocook.dto.recipe;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class IngredientDto {
    private String ingredientName;
    private String amount;
}
