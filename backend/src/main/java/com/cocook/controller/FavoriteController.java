package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.dto.favorite.AddFavoriteReqDto;
import com.cocook.service.FavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/v1/favorite")
public class FavoriteController {

    private final FavoriteService favoriteService;

    @Autowired
    public FavoriteController(FavoriteService favoriteService) {
        this.favoriteService = favoriteService;
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Object>> addFavorite(@RequestHeader("AUTH-TOKEN") String authToken, @Valid @RequestBody AddFavoriteReqDto addFavoriteReqDto) {
        favoriteService.addFavorite(authToken, addFavoriteReqDto);
        return ApiResponse.ok(null);
    }

    @DeleteMapping("/{recipeIdx}")
    public ResponseEntity<ApiResponse<Object>> deleteFavorite(@RequestHeader("AUTH-TOKEN") String authToken, @PathVariable Long recipeIdx ) {
        favoriteService.deleteFavorite(authToken, recipeIdx);
        return ApiResponse.ok(null);
    }

}
