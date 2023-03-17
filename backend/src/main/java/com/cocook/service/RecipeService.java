package com.cocook.service;

import com.cocook.dto.db.*;
import com.cocook.entity.*;
import com.cocook.repository.*;
import com.cocook.util.S3Uploader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

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

    @Autowired
    private S3Uploader s3Uploader;

    public void makeRecipe (RecipeDetailReqDto recipeDetail,
                List<IngredientReqDto> ingredients,
                String categoryName,
                List<String> themeNames,
                List<StepReqDto> steps,
                MultipartFile recipeImg,
                List<MultipartFile> stepImgs) {

        Category category = categoryRepository.getCategoryByCategoryName(categoryName);

        String storedFilePath;
        try {
            storedFilePath = s3Uploader.upload(recipeImg,"images");
        } catch (IOException e) {
            throw new RuntimeException(e.getMessage());
        }

        Recipe recipe = Recipe.builder()
                .category(category)
                .recipeName(recipeDetail.getRecipeName())
                .difficulty(recipeDetail.getDifficulty())
                .runningTime(recipeDetail.getRunningTime())
                .serving(recipeDetail.getServing())
                .imgPath(storedFilePath)
                .calorie(recipeDetail.getCalorie())
                .carb(recipeDetail.getCarb())
                .protein(recipeDetail.getProtein())
                .fat(recipeDetail.getFat()).build();
        Recipe newRecipe = recipeRepository.save(recipe);

        stepService.makeSteps(newRecipe, steps, stepImgs);

        for (IngredientReqDto ingredientReqDto: ingredients) {
            Ingredient ingredient = ingredientService.getIngredient(ingredientReqDto);
            amountService.makeAmount(recipe, ingredient, ingredientReqDto.getContent());
        }

        for (String themeName: themeNames) {
            Theme theme = themeRepository.getThemeByThemeName(themeName);
            tagService.makeTag(newRecipe, theme);
        }

    }
}
