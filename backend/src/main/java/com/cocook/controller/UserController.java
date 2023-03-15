package com.cocook.controller;

import com.cocook.dto.ApiResponse;
import com.cocook.dto.user.LoginRequestDto;
import com.cocook.dto.user.LoginResponseDto;
import com.cocook.dto.user.SignupRequestDto;
import com.cocook.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

@RestController
@RequestMapping("/api/v1/account")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/check")
    public ResponseEntity<ApiResponse<LoginResponseDto>> login(@Valid @RequestBody LoginRequestDto loginRequestDto) {
        LoginResponseDto loginResponseDto = userService.login(loginRequestDto.getAccess_token());
        return ApiResponse.ok(loginResponseDto);
    }

    @PostMapping("/signup")
    public ResponseEntity<ApiResponse<LoginResponseDto>> signup(@Valid @RequestBody SignupRequestDto signupRequestDto) {
        LoginResponseDto loginResponseDto = userService.signup(signupRequestDto);
        return ApiResponse.ok(loginResponseDto);
    }

}
