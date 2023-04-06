package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.db.*;
import com.cocook.dto.recipe.*;
import com.cocook.dto.review.ReviewListResDto;
import com.cocook.dto.review.ReviewResDto;
import com.cocook.entity.*;
import com.cocook.repository.*;
import com.cocook.util.S3Uploader;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.persistence.EntityNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

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
    private final LikeRepository likeRepository;
    private final TagService tagService;
    private final StepService stepService;
    private final IngredientService ingredientService;
    private final AmountService amountService;
    private final S3Uploader s3Uploader;
    private final JwtTokenProvider jwtTokenProvider;
    private final RedisTemplate<String, String> redisTemplate;


    public RecipeService(RecipeRepository recipeRepository, CategoryRepository categoryRepository,
                         IngredientRepository ingredientRepository, StepRepository stepRepository,
                         ThemeRepository themeRepository, FavoriteRepository favoriteRepository,
                         ReviewRepository reviewRepository, AmountRepository amountRepository,
                         LikeRepository likeRepository, TagService tagService, StepService stepService,
                         IngredientService ingredientService, AmountService amountService, S3Uploader s3Uploader,
                         JwtTokenProvider jwtTokenProvider, RedisTemplate<String, String> redisTemplate) {
        this.recipeRepository = recipeRepository;
        this.categoryRepository = categoryRepository;
        this.ingredientRepository = ingredientRepository;
        this.stepRepository = stepRepository;
        this.themeRepository = themeRepository;
        this.favoriteRepository = favoriteRepository;
        this.reviewRepository = reviewRepository;
        this.amountRepository = amountRepository;
        this.likeRepository = likeRepository;
        this.tagService = tagService;
        this.stepService = stepService;
        this.ingredientService = ingredientService;
        this.amountService = amountService;
        this.s3Uploader = s3Uploader;
        this.jwtTokenProvider = jwtTokenProvider;
        this.redisTemplate = redisTemplate;
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

        if (recipe == null) {
            throw new EntityNotFoundException("해당 레시피가 존재하지 않습니다.");
        }

        Favorite favorite = favoriteRepository.findByUserIdAndRecipeId(userIdx, recipeIdx);
        boolean isFavorite = favorite != null;

        ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
        Long length = zSetOperations.size(userIdx.toString());
        zSetOperations.add(userIdx.toString(), recipeIdx.toString(), System.currentTimeMillis());
        if (length != null && length >= 10) {
            zSetOperations.removeRange(userIdx.toString(), 0, 0);
        }

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
                    .timer(step.getTimer())
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
            LikeReview foundLiked = likeRepository.findByUserIdAndReviewId(user.getId(), review.getId());
            boolean isLiked = foundLiked != null;
            ReviewResDto recipeReview = new ReviewResDto(review.getId(), user.getId(), review.getCreatedDate(), user.getNickname(), review.getContent(), review.getImgPath(),
                    review.getLikeCnt(), review.getCommentCnt(), review.getRunningTime(), isLiked);
            recipeReviews.add(recipeReview);
        }
        for (Review review : otherReview) {
            String userNickname = review.getUser().getNickname();
            if (!review.getUser().getIsActive()) {
                userNickname = "알 수 없음";
            }
            Long userIdx = review.getUser().getId();
            LikeReview foundLiked = likeRepository.findByUserIdAndReviewId(user.getId(), review.getId());
            boolean isLiked = foundLiked != null;
            ReviewResDto recipeReview = new ReviewResDto(review.getId(), userIdx, review.getCreatedDate(), userNickname, review.getContent(), review.getImgPath(),
                    review.getLikeCnt(), review.getCommentCnt(), review.getRunningTime(), isLiked);
            recipeReviews.add(recipeReview);
        }
        return new ReviewListResDto(recipeReviews);

    }

}
