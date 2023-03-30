package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.dto.db.*;
import com.cocook.service.CategoryService;
import com.cocook.service.IngredientService;
import com.cocook.service.RecipeService;
import com.cocook.service.ThemeService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.tomcat.util.json.JSONParser;
import org.apache.tomcat.util.json.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.configurationprocessor.json.JSONObject;
import org.springframework.data.repository.query.Param;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/db")
public class DbController {

    private CategoryService categoryService;
    private ThemeService themeService;
    private RecipeService recipeService;
    private IngredientService ingredientService;
    private ObjectMapper objectMapper;

    @Autowired
    public DbController(CategoryService categoryService, ThemeService themeService, RecipeService recipeService,
                        ObjectMapper objectMapper, IngredientService ingredientService) {
        this.categoryService = categoryService;
        this.themeService = themeService;
        this.recipeService = recipeService;
        this.objectMapper = objectMapper;
        this.ingredientService = ingredientService;
    }

    @PostMapping(value = "/category", consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<CategoryResDto> makeCategory (@RequestPart String categoryName, @RequestPart MultipartFile categoryImg) {
        CategoryResDto categoryResDto = categoryService.makeCategory(categoryName, categoryImg);
        return new ResponseEntity<>(categoryResDto, HttpStatus.OK);
    }

    @PostMapping(value = "/theme", consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<ThemeResDto> makeTheme (@RequestPart String themeName, @RequestPart MultipartFile themeImg) {
        ThemeResDto themeResDto = themeService.makeTheme(themeName, themeImg);
        return new ResponseEntity<>(themeResDto, HttpStatus.OK);
    }

    @PostMapping(value = "/recipe", consumes = {MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<String> makeRecipe (@RequestParam("recipe") String recipe,
                                            @RequestParam("ingredients") String ingredients,
                                            @RequestParam("category") String category,
                                            @RequestParam("themes") String themes,
                                            @RequestParam String steps,
                                            @RequestPart("recipeImg") MultipartFile recipeImg,
                                            @RequestPart("stepImgs") List<MultipartFile> stepImgs) {

        try {
            RecipeDetailReqDto recipeDetail = objectMapper.readValue(recipe, RecipeDetailReqDto.class);

            List<Map<String, Object>> newIngredients = objectMapper.readValue(ingredients, List.class);
            List<IngredientReqDto> ingredientsReqDto = new ArrayList<>();
            for (Map<String, Object> ingredientMap : newIngredients) {
                IngredientReqDto ingredientReqDto = objectMapper.convertValue(ingredientMap, IngredientReqDto.class);
                ingredientsReqDto.add(ingredientReqDto);
            }

            List<String> newThemes = objectMapper.readValue(themes, List.class);

            List<Map<String, Object>> newSteps = objectMapper.readValue(steps, List.class);
            List<StepReqDto> stepsReqDto = new ArrayList<>();
            for (Map<String, Object> stepMap : newSteps) {
                StepReqDto stepReqDto = objectMapper.convertValue(stepMap, StepReqDto.class);
                stepsReqDto.add(stepReqDto);
            }

            recipeService.makeRecipe(recipeDetail,
                    ingredientsReqDto,
                    category,
                    newThemes,
                    stepsReqDto,
                    recipeImg,
                    stepImgs);
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
        return new ResponseEntity<>("ok", HttpStatus.OK);
    }

}
