package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.dto.home.CategoryResDto;
import com.cocook.dto.home.RandomResDto;
import com.cocook.dto.home.RecommendResDto;
import com.cocook.dto.home.ThemeResDto;
import com.cocook.dto.recipe.RecipeListResDto;
import com.cocook.service.HomeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/home")
public class HomeController {

    private final HomeService homeService;

    @Autowired
    public HomeController(HomeService homeService) {
        this.homeService = homeService;
    }

    @GetMapping("/recommend")
    public ResponseEntity<ApiResponse<RecommendResDto>> getRecommendRecipes(@RequestHeader("AUTH-TOKEN") String authToken) {
        RecommendResDto recommendResDto = homeService.getRecommendRecipes(authToken);
        return ApiResponse.ok(recommendResDto);
    }

    @GetMapping("/theme")
    public ResponseEntity<ApiResponse<List<ThemeResDto>>> getThemes() {
        List<ThemeResDto> themeResDtos = homeService.getThemes();
        return ApiResponse.ok(themeResDtos);
    }

    @GetMapping("/category")
    public ResponseEntity<ApiResponse<List<CategoryResDto>>> getCategories() {
        List<CategoryResDto> categoryResDtos = homeService.getCategories();
        return ApiResponse.ok(categoryResDtos);
    }

    @GetMapping("/random")
    public ResponseEntity<ApiResponse<RandomResDto>> getRandomRecipes(@RequestHeader("AUTH-TOKEN") String authToken) {
        RandomResDto randomResDto = homeService.getRandomRecipes(authToken);
        return ApiResponse.ok(randomResDto);
    }

}
