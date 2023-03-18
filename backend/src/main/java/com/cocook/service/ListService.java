package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.list.RecipeDetailResDto;
import com.cocook.dto.list.RecipeListResDto;
import com.cocook.entity.Recipe;
import com.cocook.repository.CategoryRepository;
import com.cocook.repository.FavoriteRepository;
import com.cocook.repository.RecipeRepository;
import com.cocook.repository.ThemeRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import javax.persistence.EntityNotFoundException;
import java.util.*;

@Service
@AllArgsConstructor
public class ListService {

    private JwtTokenProvider jwtTokenProvider;
    private RecipeRepository recipeRepository;
    private FavoriteRepository favoriteRepository;
    private ThemeRepository themeRepository;
    private CategoryRepository categoryRepository;

    public RecipeListResDto getRecipesByThemeName(String authToken, String themeName, String difficulty, Integer time) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);

        if (themeRepository.getThemeByThemeName(themeName) == null) {
            throw new EntityNotFoundException("해당 테마가 존재하지 않습니다.");
        }

        List<Recipe> foundRecipes = recipeRepository.findByThemeName(themeName);

        return getRecipesByDifficultyAndTime(foundRecipes, userIdx, difficulty, time);
    }

    public RecipeListResDto getRecipesByCategoryName(String authToken, String categoryName, String difficulty, Integer time) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);

        if (categoryRepository.getCategoryByCategoryName(categoryName) == null) {
            throw new EntityNotFoundException("해당 카테고리가 존재하지 않습니다.");
        }

        List<Recipe> foundRecipes = recipeRepository.findByCategoryCategoryName(categoryName);

        return getRecipesByDifficultyAndTime(foundRecipes, userIdx, difficulty, time);
    }

    private RecipeListResDto getRecipesByDifficultyAndTime(List<Recipe> recipes, Long userIdx, String difficulty, Integer time) {
        List<RecipeDetailResDto> newRecipes = new ArrayList<>();

        Set<String> difficultySet = new HashSet<>();
        switch (difficulty) {
            case "쉬움":
                difficultySet.add("쉬움");
                break;
            case "보통":
                difficultySet.add("보통");
                break;
            case "어려움":
                difficultySet.add("어려움");
                break;
            case "전체":
                difficultySet.add("쉬움");
                difficultySet.add("보통");
                difficultySet.add("어려움");
                break;
        }

        for (Recipe recipe : recipes) {
            if (!difficultySet.contains(recipe.getDifficulty())) {
                continue;
            }
            if (time != 0 && recipe.getRunningTime() > time) {
                continue;
            }
            boolean isFavorite;
            if (favoriteRepository.findByUserIdAndRecipeId(userIdx, recipe.getId()) == null) {
                isFavorite = false;
            } else {
                isFavorite = true;
            }
            RecipeDetailResDto recipeDetailResDto = RecipeDetailResDto.builder()
                    .recipeName(recipe.getRecipeName())
                    .recipeDifficulty(recipe.getDifficulty())
                    .recipeIdx(recipe.getId())
                    .recipeImgPath(recipe.getImgPath())
                    .recipeRunningTime(recipe.getRunningTime())
                    .isFavorite(isFavorite)
                    .build();

            newRecipes.add(recipeDetailResDto);
        }

        return new RecipeListResDto(newRecipes);
    }

}
