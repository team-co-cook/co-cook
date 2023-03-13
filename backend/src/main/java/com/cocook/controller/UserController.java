package com.cocook.controller;

import com.cocook.dto.user.LoginRequestDto;
import com.cocook.dto.user.LoginResponseDto;
import com.cocook.dto.user.SignupRequestDto;
import com.cocook.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;

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
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequestDto loginRequestDto) {
        try {
            LoginResponseDto loginResponseDto = userService.login(loginRequestDto.getAccess_token());
            return new ResponseEntity<>(loginResponseDto, HttpStatus.OK);
        } catch (HttpClientErrorException e) {
            return new ResponseEntity<>(e.getMessage(), e.getStatusCode());
        }
    }

    @PostMapping("/signup")
    public ResponseEntity<?> signup(@Valid @RequestBody SignupRequestDto signupRequestDto) {
        try {
            LoginResponseDto loginResponseDto = userService.signup(signupRequestDto);
            return new ResponseEntity<>(loginResponseDto, HttpStatus.CREATED);
        } catch (HttpClientErrorException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.UNAUTHORIZED);
        } catch (DataIntegrityViolationException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.CONFLICT);
        }
    }

}
