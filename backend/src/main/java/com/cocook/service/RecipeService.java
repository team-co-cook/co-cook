package com.cocook.service;

import com.cocook.dto.db.*;
import com.cocook.entity.*;
import com.cocook.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class RecipeService {
    @Autowired
    private RecipeRepository recipeRepository;
    @Autowired
    private CategoryRepository categoryRepository;
    @Autowired
    private IngredientRepository ingredientRepository;
    @Autowired
    private StepRepository stepRepository;
    @Autowired
    private ThemeRepository themeRepository;
    @Autowired
    private TagService tagService;
    @Autowired
    private StepService stepService;

    @Autowired
    private IngredientService ingredientService;

    @Autowired
    private AmountService amountService;

    public void makeRecipe (RecipeReqDto recipeReqDto) {
        String categoryName = recipeReqDto.getCategory();
        List<String> themeNames = recipeReqDto.getThemes();
        List<StepReqDto> steps = recipeReqDto.getSteps();
        List<IngredientReqDto> ingredients = recipeReqDto.getIngredient();
        System.out.println(categoryName);
        Category category = categoryRepository.getCategoryByCategoryName(categoryName);
        System.out.println(recipeReqDto.getRecipe());
        RecipeDetailReqDto recipeDetail = recipeReqDto.getRecipe();
        System.out.println("===========================================");

        Recipe recipe = Recipe.builder()
                .category(category)
                .recipeName(recipeDetail.getRecipeName())
                .difficulty(recipeDetail.getDifficulty())
                .runningTime(recipeDetail.getRunningTime())
                .serving(recipeDetail.getServing())
                .imgPath(recipeDetail.getImgPath())
                .calorie(recipeDetail.getCalorie())
                .carb(recipeDetail.getCarb())
                .protein(recipeDetail.getProtein())
                .fat(recipeDetail.getFat()).build();
        Recipe newRecipe = recipeRepository.save(recipe);

        for (StepReqDto stepReqDto: steps) {
            stepService.makeSteps(newRecipe, stepReqDto);
        }

        for (IngredientReqDto ingredientReqDto: ingredients) {
            Ingredient ingredient = ingredientService.getIngredient(ingredientReqDto);
            amountService.makeAmount(recipe, ingredient, ingredientReqDto.getContent());
        }

        for (String themeName: themeNames) {
            Theme theme = themeRepository.getThemeByThemeName(themeName);
            tagService.makeTag(newRecipe, theme);
        }
        System.out.println(newRecipe);
    }
}
