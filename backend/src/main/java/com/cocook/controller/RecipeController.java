package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.dto.recipe.RecipeDetailResDto;
import com.cocook.dto.recipe.RecipeInfoResDto;
import com.cocook.dto.recipe.RecipeStepResDto;
import com.cocook.dto.review.ReviewListResDto;
import com.cocook.service.RecipeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.parameters.P;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/recipe")
public class RecipeController {
    private final RecipeService recipeService;

    @Autowired
    public RecipeController(RecipeService recipeService) { this.recipeService = recipeService; }

    @GetMapping("/info/{recipe_idx}")
    public ResponseEntity<ApiResponse<RecipeInfoResDto>> getRecipeInfo(@RequestHeader("AUTH-TOKEN") String authToken,
                                                                       @PathVariable Long recipe_idx) {
        RecipeInfoResDto recipeInfoResDto = recipeService.getRecipeInfo(recipe_idx, authToken);
        return ApiResponse.ok(recipeInfoResDto);
    }

    @GetMapping("/detail/{recipe_idx}")
    public ResponseEntity<ApiResponse<RecipeDetailResDto>> getRecipeDetail(@RequestHeader("AUTH-TOKEN") String authToken,
                                                                           @PathVariable("recipe_idx") Long recipeIdx) {
        RecipeDetailResDto recipeDetailResDto = recipeService.getRecipeDetail(recipeIdx);
        return ApiResponse.ok(recipeDetailResDto);
    }

    @GetMapping("/step/{recipe_idx}")
    public ResponseEntity<ApiResponse<RecipeStepResDto>> getRecipeStep(@RequestHeader("AUTH-TOKEN") String authToken,
                                                                       @PathVariable Long recipe_idx) {
        RecipeStepResDto recipeStepResDto = recipeService.getRecipeStep(recipe_idx);
        return ApiResponse.ok(recipeStepResDto);
    }

    @GetMapping("/review/{recipe_idx}")
    public ResponseEntity<ApiResponse<ReviewListResDto>> getRecipeReview(@RequestHeader("AUTH-TOKEN") String authToken,
                                                                         @PathVariable Long recipe_idx) {
        return ApiResponse.ok(recipeService.getRecipeReview(recipe_idx, authToken));
    }
}
