package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.dto.user.ChangeNicknameRequestDto;
import com.cocook.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/v1/mypage")
public class MyPageController {

    private final UserService userService;

    @Autowired
    public MyPageController(UserService userService) {
        this.userService = userService;
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

}