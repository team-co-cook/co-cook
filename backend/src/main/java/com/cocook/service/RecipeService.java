package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.db.*;
import com.cocook.dto.recipe.*;
import com.cocook.dto.review.ReviewListResDto;
import com.cocook.dto.review.ReviewResDto;
import com.cocook.entity.*;
import com.cocook.repository.*;
import com.cocook.util.S3Uploader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service

public class RecipeService {
    private final RecipeRepository recipeRepository;
    private final CategoryRepository categoryRepository;
    private final IngredientRepository ingredientRepository;
    private final StepRepository stepRepository;
    private final ThemeRepository themeRepository;
    private final FavoriteRepository favoriteRepository;
    private final ReviewRepository reviewRepository;
    private final AmountRepository amountRepository;
    private final TagService tagService;
    private final StepService stepService;
    private final IngredientService ingredientService;
    private final AmountService amountService;
    private final S3Uploader s3Uploader;
    private final JwtTokenProvider jwtTokenProvider;

    @Autowired
    public RecipeService(RecipeRepository recipeRepository, CategoryRepository categoryRepository, IngredientRepository ingredientRepository,
                         StepRepository stepRepository, ThemeRepository themeRepository, TagService tagService, StepService stepService,
                         IngredientService ingredientService, AmountService amountService, S3Uploader s3Uploader, FavoriteRepository favoriteRepository,
                         JwtTokenProvider jwtTokenProvider, ReviewRepository reviewRepository, AmountRepository amountRepository) {
        this.recipeRepository = recipeRepository;
        this.categoryRepository = categoryRepository;
        this.ingredientRepository = ingredientRepository;
        this.stepRepository = stepRepository;
        this.themeRepository = themeRepository;
        this.reviewRepository = reviewRepository;
        this.amountRepository = amountRepository;
        this.tagService = tagService;
        this.stepService = stepService;
        this.ingredientService = ingredientService;
        this.amountService = amountService;
        this.s3Uploader = s3Uploader;
        this.favoriteRepository = favoriteRepository;
        this.jwtTokenProvider = jwtTokenProvider;
    }

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
    public RecipeInfoResDto getRecipeInfo(Long recipeIdx, String authToken) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);
        Recipe recipe = recipeRepository.findRecipeById(recipeIdx);
        Favorite favorite = favoriteRepository.findByUserIdAndRecipeId(userIdx, recipeIdx);
        boolean isFavorite = favorite != null;
        return RecipeInfoResDto.builder()
                .recipeName(recipe.getRecipeName())
                .recipeImgPath(recipe.getImgPath())
                .recipeDifficulty(recipe.getDifficulty())
                .recipeRunningTime(recipe.getRunningTime())
                .isFavorite(isFavorite).build();
    }

    public RecipeDetailResDto getRecipeDetail(Long recipeIdx) {
        Recipe recipe = recipeRepository.findRecipeById(recipeIdx);
        List<Ingredient> ingredients = ingredientRepository.findIngredientsByRecipeIdx(recipeIdx);
        List<IngredientDto> ingredientDtos = new ArrayList<>();
        for (Ingredient ingredient : ingredients) {
            Amount amount = amountRepository.findAmountByRecipeIdAndIngredientId(recipeIdx, ingredient.getId());
            String recipeAmount = amount.getContent();
            IngredientDto ingredientDto = new IngredientDto(ingredient.getIngredientName(), recipeAmount);
            ingredientDtos.add(ingredientDto);
        }
        return RecipeDetailResDto.builder()
                .calorie(recipe.getCalorie())
                .serving(recipe.getServing())
                .carb(recipe.getCarb())
                .protein(recipe.getProtein())
                .fat(recipe.getFat())
                .ingredients(ingredientDtos).build();
    }

    public RecipeStepResDto getRecipeStep(Long recipeIdx) {
        List<Step> steps = stepRepository.findStepsByRecipeId(recipeIdx);
        List<RecipeStepDetailResDto> recipeStepDetailResDtos = new ArrayList<>();

        for (Step step : steps) {
            RecipeStepDetailResDto recipeStepDetailResDto = RecipeStepDetailResDto.builder()
                    .currentStep(step.getCurrentStep())
                    .timer(step.getCurrentStep())
                    .content(step.getContent())
                    .imgPath(step.getImgPath())
                    .build();
            recipeStepDetailResDtos.add(recipeStepDetailResDto);
        }
        return RecipeStepResDto.builder().steps(recipeStepDetailResDtos).build();
    }

    public ReviewListResDto getRecipeReview(Long recipeIdx, String authToken) {
        User user = jwtTokenProvider.getUser(authToken);
        List<Review> reviewList = reviewRepository.findReviewsByRecipeIdOrderByIdDesc(recipeIdx);
        List<Review> userReview = new ArrayList<>();
        List<Review> otherReview = new ArrayList<>();

        for (Review review : reviewList) {
            if (review.getUser() == user) {
                userReview.add(review);
            } else {
                otherReview.add(review);
            }
        }
        List<ReviewResDto> recipeReviews = new ArrayList<>();
        for (Review review : userReview) {
            ReviewResDto recipeReview = new ReviewResDto(review.getId(), review.getCreatedDate(), user.getNickname(), review.getContent(), review.getImgPath(),
                    review.getLikeCnt(), review.getCommentCnt(), review.getRunningTime());
            recipeReviews.add(recipeReview);
        }
        for (Review review : otherReview) {
            String userNickname = review.getUser().getNickname();
            ReviewResDto recipeReview = new ReviewResDto(review.getId(), review.getCreatedDate(), userNickname, review.getContent(), review.getImgPath(),
                    review.getLikeCnt(), review.getCommentCnt(), review.getRunningTime());
            recipeReviews.add(recipeReview);
        }
        return new ReviewListResDto(recipeReviews);

    }
}
