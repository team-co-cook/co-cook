package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.list.RecipeDetailResDto;
import com.cocook.dto.list.RecipeListResDto;
import com.cocook.dto.list.RecipeWithIngredientResDto;
import com.cocook.dto.list.RecipesContainingIngredientsCnt;
import com.cocook.entity.Amount;
import com.cocook.entity.Recipe;
import com.cocook.repository.*;
import com.cocook.util.WordSimilarity;
import com.github.jfasttext.JFastText;
import lombok.AllArgsConstructor;

import org.joda.time.DateTime;
import org.springframework.data.redis.core.ListOperations;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import javax.persistence.EntityNotFoundException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class ListService {

    private final JwtTokenProvider jwtTokenProvider;
    private final RecipeRepository recipeRepository;
    private final FavoriteRepository favoriteRepository;
    private final ThemeRepository themeRepository;
    private final CategoryRepository categoryRepository;
    private final AmountRepository amountRepository;
    private final RedisTemplate<String, String> redisTemplate;
    private final JFastText fastText;
    private final WordSimilarity wordSimilarity;

//    @Autowired
    public ListService(JwtTokenProvider jwtTokenProvider, RecipeRepository recipeRepository,
                       FavoriteRepository favoriteRepository, ThemeRepository themeRepository,
                       CategoryRepository categoryRepository, AmountRepository amountRepository,
                       RedisTemplate<String, String> redisTemplate,
                       JFastText fastText, WordSimilarity wordSimilarity) {
        this.jwtTokenProvider = jwtTokenProvider;
        this.recipeRepository = recipeRepository;
        this.favoriteRepository = favoriteRepository;
        this.themeRepository = themeRepository;
        this.categoryRepository = categoryRepository;
        this.amountRepository = amountRepository;
        this.redisTemplate = redisTemplate;
        this.fastText = fastText;
        this.wordSimilarity = wordSimilarity;
//        this.wordVector = WordVectorSerializer.loadTxtVectors(new File("src/main/resources/ko.bin"));
    }

    public RecipeListResDto getRecipesByThemeName(String authToken, String themeName, String difficulty, Integer time) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);

        if (themeRepository.getThemeByThemeName(themeName) == null) {
            throw new EntityNotFoundException("해당 테마가 존재하지 않습니다.");
        }

        List<Recipe> foundRecipes = recipeRepository.findByThemeNameOrderByIdDesc(themeName);

        return getRecipesByDifficultyAndTime(foundRecipes, userIdx, difficulty, time);
    }

    public RecipeListResDto getRecipesByCategoryName(String authToken, String categoryName, String difficulty, Integer time) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);

        if (categoryRepository.getCategoryByCategoryName(categoryName) == null) {
            throw new EntityNotFoundException("해당 카테고리가 존재하지 않습니다.");
        }

        List<Recipe> foundRecipes = recipeRepository.findByCategoryCategoryNameOrderByIdDesc(categoryName);

        return getRecipesByDifficultyAndTime(foundRecipes, userIdx, difficulty, time);
    }

    public RecipeListResDto getAllRecipes(String authToken, String difficulty, Integer time) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);
        List<Recipe> foundRecipes = recipeRepository.findAllByOrderByIdDesc();
        return getRecipesByDifficultyAndTime(foundRecipes, userIdx, difficulty, time);
    }


    public RecipeListResDto getRecipesByKeyword(String authToken, String keyword) {
        if (keyword.trim().isEmpty()) {
            throw new EntityNotFoundException("키워드를 입력해주세요.");
        }
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);
        List<Recipe> foundRecipes = recipeRepository.findByRecipeNameContainingOrderByIdDesc(keyword);

        List<Recipe> relatedRecipes = recipeRepository.findAll();
        List<Float> keywordVector = fastText.getVector(keyword);
        relatedRecipes.sort(Comparator.comparingDouble(recipe -> -wordSimilarity.getCosineSimilarity(fastText, keywordVector, recipe.getRecipeName())));
        for (Recipe recipe : relatedRecipes) {
            if ((wordSimilarity.getCosineSimilarity(fastText, keywordVector, recipe.getRecipeName()) > 0.713)) {
                if (!foundRecipes.contains(recipe)){
                    foundRecipes.add(recipe);
                }
            } else { break; }
        }

        List<RecipeDetailResDto> newRecipes = new ArrayList<>();
        ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
        ListOperations<String, String> listOperations = redisTemplate.opsForList();
        ValueOperations<String, String> valueOperations = redisTemplate.opsForValue();
        Integer current = LocalDateTime.now().getHour();
        if (valueOperations.get("recent") == null) {
            valueOperations.set("recent", current.toString());
        }
        Integer recent = Integer.valueOf(valueOperations.get("recent"));

        if (current != recent) {
            Integer diff = current - recent;
            if (diff < 0) {
                diff = 24 + diff;
            }
            valueOperations.set("recent", current.toString());
            Integer pastCounts = 0;
            for (int i = 0; i < diff; i++) {
                Integer count = 0;
                if (listOperations.size("searchCountsList") == 24) {
                    count = Integer.parseInt(listOperations.leftPop("searchCountsList"));
                }
                pastCounts += count;
                listOperations.rightPush("searchCountsList", "0");
            }
            while (pastCounts > 0) {
                String target = listOperations.leftPop("searchHistoryList");
                zSetOperations.incrementScore("searchHistorySet", target, -1);
                Double score = zSetOperations.score("searchHistorySet", target);
                if (score != null && score == 0) {
                    zSetOperations.remove("searchHistorySet", target);
                }
                pastCounts -= 1;
            }
        }
        Integer currentCounts = 0;
        if (listOperations.size("searchCountsList") != null) {
            if (listOperations.size("searchCountsList") != 0L) {
                System.out.println(listOperations.size("searchCountsList"));
                currentCounts = Integer.parseInt(listOperations.rightPop("searchCountsList"));
            }
        }

        for (Recipe recipe : foundRecipes) {
            RecipeDetailResDto recipeDetailResDto = getRecipeDetailDtoWithIsFavorite(userIdx, recipe);
            newRecipes.add(recipeDetailResDto);
            zSetOperations.incrementScore("searchHistorySet", recipe.getRecipeName(), 1);
            if (recipe.getCategory().getCategoryName() == "메인 요리") {
                zSetOperations.incrementScore("searchHistorySet", recipe.getRecipeName(), 1);
            }
            listOperations.rightPush("searchHistoryList", recipe.getRecipeName());
            currentCounts += 1;
        }
        listOperations.rightPush("searchCountsList", currentCounts.toString());

        return new RecipeListResDto(newRecipes);
    }

    public RecipeListResDto getRecipesByFavorite(String authToken) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);
        List<Recipe> foundRecipes = recipeRepository.findRecipesByUserId(userIdx);
        List<RecipeDetailResDto> newRecipes = new ArrayList<>();

        for (Recipe recipe : foundRecipes) {
            RecipeDetailResDto recipeDetailResDto =  RecipeDetailResDto.builder()
                    .recipeName(recipe.getRecipeName())
                    .recipeDifficulty(recipe.getDifficulty())
                    .recipeIdx(recipe.getId())
                    .recipeImgPath(recipe.getImgPath())
                    .recipeRunningTime(recipe.getRunningTime())
                    .isFavorite(true)
                    .build();
            newRecipes.add(recipeDetailResDto);
        }
        return new RecipeListResDto(newRecipes);
    }

    public List<RecipeWithIngredientResDto> getRecipesByIngredients(String authToken, List<String> ingredients) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);
        List<String> notBlankIngredients = new ArrayList<>();
        for (String ingredient : ingredients) {
            notBlankIngredients.add(ingredient.replace(" ", ""));
        }
        List<RecipesContainingIngredientsCnt> recipesContainingIngredientsCnts = recipeRepository.findRecipesByIngredients(notBlankIngredients, userIdx);
        List<RecipeWithIngredientResDto> recipeWithIngredientResDtos = new ArrayList<>();
        for (RecipesContainingIngredientsCnt r : recipesContainingIngredientsCnts) {
            Boolean isFavorite = r.getIsFavorite() == 1;
            RecipeWithIngredientResDto recipeWithIngredientResDto = RecipeWithIngredientResDto.builder()
                    .recipeIdx(r.getRecipeIdx())
                    .recipeName(r.getRecipeName())
                    .recipeImgPath(r.getRecipeImgPath())
                    .recipeRunningTime(r.getRecipeRunningTime())
                    .recipeDifficulty(r.getRecipeDifficulty())
                    .includingIngredientCnt(r.getIncludingIngredientCnt())
                    .totalIngredientCnt(r.getTotalIngredientCnt())
                    .isFavorite(isFavorite).build();
            recipeWithIngredientResDtos.add(recipeWithIngredientResDto);
        }
        return recipeWithIngredientResDtos;
    }

    public List<RecipeWithIngredientResDto> getRecipesByIngredientsOriginal(String authToken, List<String> ingredientNames) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);
        List<Recipe> foundRecipes = recipeRepository.findByIngredients(ingredientNames);
        List<RecipeWithIngredientResDto> recipeWithIngredientResDtos = new ArrayList<>();

        for (Recipe recipe : foundRecipes) {
            List<Amount> amounts = amountRepository.findAmountsByRecipeId(recipe.getId());
            int includingIngredientsCnt = 0;
            for (Amount amount : amounts) {
                if (ingredientNames.contains(amount.getIngredient().getIngredientName())) {
                    includingIngredientsCnt += 1;
                }
            }

            boolean isFavorite;
            if (favoriteRepository.findByUserIdAndRecipeId(userIdx, recipe.getId()) == null) {
                isFavorite = false;
            } else {
                isFavorite = true;
            }

            RecipeWithIngredientResDto recipeWithIngredientResDto = RecipeWithIngredientResDto.builder()
                    .recipeName(recipe.getRecipeName())
                    .recipeDifficulty(recipe.getDifficulty())
                    .recipeRunningTime(recipe.getRunningTime())
                    .recipeImgPath(recipe.getImgPath())
                    .recipeIdx(recipe.getId())
                    .totalIngredientCnt(amounts.size())
                    .includingIngredientCnt(includingIngredientsCnt)
                    .isFavorite(isFavorite)
                    .build();
            recipeWithIngredientResDtos.add(recipeWithIngredientResDto);
        }

        Set<RecipeWithIngredientResDto> setWithoutDuplicates = new HashSet<>(recipeWithIngredientResDtos);
        List<RecipeWithIngredientResDto> sortedListWithoutDuplicates = new ArrayList<>(setWithoutDuplicates);
        Collections.sort(sortedListWithoutDuplicates, new Comparator<RecipeWithIngredientResDto>() {
            @Override
            public int compare(RecipeWithIngredientResDto o1, RecipeWithIngredientResDto o2) {
                return Integer.compare(o2.getIncludingIngredientCnt(), o1.getIncludingIngredientCnt());
            }
        });

        return sortedListWithoutDuplicates;
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
            default:
                throw new EntityNotFoundException("난이도는 ['쉬움', '보통', '어려움', '전체']만 가능합니다.");
        }

        for (Recipe recipe : recipes) {
            if (!difficultySet.contains(recipe.getDifficulty())) {
                continue;
            }
            if (time != 0 && recipe.getRunningTime() > time) {
                continue;
            }
            RecipeDetailResDto recipeDetailResDto = getRecipeDetailDtoWithIsFavorite(userIdx, recipe);
            newRecipes.add(recipeDetailResDto);
        }

        return new RecipeListResDto(newRecipes);
    }

    private RecipeDetailResDto getRecipeDetailDtoWithIsFavorite(Long userIdx, Recipe recipe) {
        boolean isFavorite;
        if (favoriteRepository.findByUserIdAndRecipeId(userIdx, recipe.getId()) == null) {
            isFavorite = false;
        } else {
            isFavorite = true;
        }
        return RecipeDetailResDto.builder()
                .recipeName(recipe.getRecipeName())
                .recipeDifficulty(recipe.getDifficulty())
                .recipeIdx(recipe.getId())
                .recipeImgPath(recipe.getImgPath())
                .recipeRunningTime(recipe.getRunningTime())
                .isFavorite(isFavorite)
                .build();
    }

}
