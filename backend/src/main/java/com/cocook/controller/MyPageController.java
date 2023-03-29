package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.dto.recipe.RecipeListResDto;
import com.cocook.dto.review.MyReview;
import com.cocook.dto.review.MyReviewResDto;
import com.cocook.dto.review.ReviewListResDto;
import com.cocook.dto.review.ReviewResDto;
import com.cocook.dto.user.ChangeNicknameRequestDto;
import com.cocook.service.RecipeService;
import com.cocook.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/v1/mypage")
public class MyPageController {

    private final UserService userService;
    private final RecipeService recipeService;

    @Autowired
    public MyPageController(UserService userService, RecipeService recipeService) {
        this.userService = userService;
        this.recipeService = recipeService;
    }

    @PutMapping("/withdrawal/{user_idx}")
    public ResponseEntity<ApiResponse<Object>> deleteUser(@PathVariable Long user_idx) {
        userService.deleteUser(user_idx);
        return ApiResponse.noContent(null);
    }

    @PutMapping("/nickname/{user_idx}")
    public ResponseEntity<ApiResponse<String>> changeUserNickname(@PathVariable Long user_idx,
                                               @Valid @RequestBody ChangeNicknameRequestDto changeNicknameRequestDto) {
        String changedNickname = userService.changeUserNickname(user_idx, changeNicknameRequestDto.getNickname());
        return ApiResponse.ok(changedNickname);
    }

    @GetMapping("/review")
    public ResponseEntity<ApiResponse<List<MyReviewResDto>>> getReviews(@RequestHeader("AUTH-TOKEN") String authToken) {
        return ApiResponse.ok(userService.getReviews(authToken));
    }

    @GetMapping("/recent")
    public ResponseEntity<ApiResponse<List<RecipeListResDto>>> getRecentRecipes(@RequestHeader("AUTH-TOKEN") String authToken) {
        return ApiResponse.ok(userService.getRecentRecipe(authToken));
    }

}
