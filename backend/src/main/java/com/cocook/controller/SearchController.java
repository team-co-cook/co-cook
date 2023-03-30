package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.entity.Ingredient;
import com.cocook.service.IngredientService;
import com.cocook.service.SearchService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/search")
public class SearchController {

    private final SearchService searchService;
    private final IngredientService ingredientService;

    public SearchController(SearchService searchService, IngredientService ingredientService) {
        this.searchService = searchService;
        this.ingredientService = ingredientService;
    }

    @GetMapping("/popular")
    public ResponseEntity<ApiResponse<List<String>>> getPopularKeywords() {
        return ApiResponse.ok(searchService.getPopularKeywords());
    }

    @GetMapping("/ingredient/{ingredientName}")
    public ResponseEntity<ApiResponse<String>> checkIngredient(@PathVariable("ingredientName") String ingredientName) {
        if (ingredientService.checkIngredient(ingredientName).isEmpty()) {
            return ApiResponse.noContent("없는 재료입니다.");
        } else {
            return ApiResponse.ok(null);
        }
    }

}
