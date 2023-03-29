package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.service.SearchService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/search")
public class SearchController {

    private final SearchService searchService;

    public SearchController(SearchService searchService) {
        this.searchService = searchService;
    }

    @GetMapping("/popular")
    public ResponseEntity<ApiResponse<List<String>>> getPopularKeywords() {
        return ApiResponse.ok(searchService.getPopularKeywords());
    }

}
