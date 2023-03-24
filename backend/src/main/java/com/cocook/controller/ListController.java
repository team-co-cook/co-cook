package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.dto.list.RecipeListResDto;
import com.cocook.dto.list.RecipeWithIngredientResDto;
import com.cocook.dto.list.RecipesContainingIngredientsCnt;
import com.cocook.service.ListService;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriUtils;

import java.nio.charset.StandardCharsets;
import java.util.List;

@RestController
@RequestMapping("/api/v1/list")
public class ListController {

    private final ListService listService;

    @Autowired
    public ListController(ListService listService) {
        this.listService = listService;
    }

    @GetMapping("/theme")
    public ResponseEntity<ApiResponse<RecipeListResDto>> getRecipesByThemeName(@RequestHeader("AUTH-TOKEN") String authToken,
                                                                               @RequestParam String themeName,
                                                                               @RequestParam String difficulty,
                                                                               @RequestParam Integer time) {
        RecipeListResDto recipeListResDto = listService.getRecipesByThemeName(authToken, themeName, difficulty, time);
        return ApiResponse.ok(recipeListResDto);
    }

    @GetMapping("/category")
    public ResponseEntity<ApiResponse<RecipeListResDto>> getRecipesByCategoryName(@RequestHeader("AUTH-TOKEN") String authToken,
                                                                               @RequestParam String categoryName,
                                                                               @RequestParam String difficulty,
                                                                               @RequestParam Integer time) {
        RecipeListResDto recipeListResDto = listService.getRecipesByCategoryName(authToken, categoryName, difficulty, time);
        return ApiResponse.ok(recipeListResDto);
    }

    @GetMapping("/all")
    public ResponseEntity<ApiResponse<RecipeListResDto>> getAllRecipes(@RequestHeader("AUTH-TOKEN") String authToken,
                                                                                  @RequestParam String difficulty,
                                                                                  @RequestParam Integer time) {
        RecipeListResDto recipeListResDto = listService.getAllRecipes(authToken, difficulty, time);
        return ApiResponse.ok(recipeListResDto);
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<RecipeListResDto>> getRecipesByKeyword(@RequestHeader("AUTH-TOKEN") String authToken,
                                                                       @RequestParam String keyword) {
        RecipeListResDto recipeListResDto = listService.getRecipesByKeyword(authToken, keyword);
        return ApiResponse.ok(recipeListResDto);
    }

    @GetMapping("/favorite")
    public ResponseEntity<ApiResponse<RecipeListResDto>> getRecipesByFavorite(@RequestHeader("AUTH-TOKEN") String authToken) {
        RecipeListResDto recipeListResDto = listService.getRecipesByFavorite(authToken);
        return ApiResponse.ok(recipeListResDto);
    }

    @GetMapping("/ingredients")
    public ResponseEntity<ApiResponse<List<RecipeWithIngredientResDto>>> getRecipesByIngredients(@RequestHeader("AUTH-TOKEN") String authToken,
                                                                                                      @RequestParam List<String> ingredients) {
        return ApiResponse.ok(listService.getRecipesByIngredients(authToken, ingredients));
    }

}
