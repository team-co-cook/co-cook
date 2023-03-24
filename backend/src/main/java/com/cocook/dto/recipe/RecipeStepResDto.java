package com.cocook.dto.recipe;

import com.cocook.entity.Step;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class RecipeStepResDto {
    List<RecipeStepDetailResDto> steps;
}
