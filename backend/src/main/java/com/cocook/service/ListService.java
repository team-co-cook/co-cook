package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.list.RecipeDetailResDto;
import com.cocook.dto.list.RecipeListResDto;
import com.cocook.entity.Recipe;
import com.cocook.repository.FavoriteRepository;
import com.cocook.repository.RecipeRepository;
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

    public RecipeListResDto getRecipesByThemeName(String authToken, String themeName, String difficulty, Integer time) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);
        List<Recipe> foundRecipes = recipeRepository.findByThemeName(themeName);

        if (foundRecipes == null) {
            throw new EntityNotFoundException("해당 테마가 존재하지 않습니다.");
        }

        List<RecipeDetailResDto> newRecipes = new ArrayList<>();

        Set<String> difficultySet = new HashSet<>();
        if (difficulty.equals("쉬움")) {
            difficultySet.add("쉬움");
        } else if (difficulty.equals("보통")) {
            difficultySet.add("보통");
        } else if (difficulty.equals("어려움")) {
            difficultySet.add("어려움");
        } else if (difficulty.equals("전체")) {
            difficultySet.add("쉬움");
            difficultySet.add("보통");
            difficultySet.add("어려움");
        }

        for (Recipe recipe : foundRecipes) {
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
