package com.cocook.controller;

import com.cocook.dto.db.*;
import com.cocook.service.CategoryService;
import com.cocook.service.RecipeService;
import com.cocook.service.ThemeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/v1/db")
public class DbController {

    @Autowired
    private CategoryService categoryService;
    @Autowired
    private ThemeService themeService;

    @Autowired
    private RecipeService recipeService;

    @PostMapping("/category")
    public ResponseEntity<CategoryResDto> makeCategory (@RequestBody CategoryReqDto categoryReqDto) {
        CategoryResDto categoryResDto = categoryService.makeCategory(categoryReqDto);
        return new ResponseEntity<>(categoryResDto, HttpStatus.ACCEPTED);
    }

    @PostMapping("/theme")
    public ResponseEntity<ThemeResDto> makeTheme (@Valid @RequestBody ThemeReqDto themeReqDto) {
        ThemeResDto themeResDto = themeService.makeTheme(themeReqDto);
        return new ResponseEntity<>(themeResDto, HttpStatus.ACCEPTED);
    }

    @PostMapping("/recipe")
    public ResponseEntity<String> makeRecipe (@Valid @RequestBody RecipeReqDto recipeReqDto) {
        recipeService.makeRecipe(recipeReqDto);
        return new ResponseEntity<>("ok", HttpStatus.ACCEPTED);
    }
}
