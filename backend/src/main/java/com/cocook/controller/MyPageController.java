package com.cocook.controller;

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

    private UserService userService;

    @Autowired
    public MyPageController(UserService userService) {
        this.userService = userService;
    }

    @PutMapping("/withdrawal/{user_idx}")
    public ResponseEntity<?> deleteUser(@PathVariable Long user_idx) {
        try {
            userService.deleteUser(user_idx);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (EmptyResultDataAccessException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @PutMapping("/nickname/{user_idx}")
    public ResponseEntity<String> changeUserNickname(@PathVariable Long user_idx,
                                               @Valid @RequestBody ChangeNicknameRequestDto changeNicknameRequestDto) {
        try {
            String changedNickname = userService.changeUserNickname(user_idx, changeNicknameRequestDto.getNickname());
            return new ResponseEntity<>(changedNickname, HttpStatus.OK);
        } catch (NullPointerException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

}
