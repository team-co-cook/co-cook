package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.user.GoogleOAuthResponseDto;
import com.cocook.dto.user.LoginResponseDto;
import com.cocook.dto.user.SignupRequestDto;
import com.cocook.entity.User;
import com.cocook.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final JwtTokenProvider jwtTokenProvider;

    @Autowired
    public UserService(UserRepository userRepository, JwtTokenProvider jwtTokenProvider) {
        this.userRepository = userRepository;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    public LoginResponseDto login(String access_token) {

        ResponseEntity<?> response = this.checkToken(access_token);
        if (response.getStatusCode() == HttpStatus.UNAUTHORIZED) {
            throw new HttpClientErrorException(HttpStatus.UNAUTHORIZED, "유효하지 않은 토큰입니다.");
        }
        GoogleOAuthResponseDto googleOAuthResponse = (GoogleOAuthResponseDto) response.getBody();

        String userEmail = googleOAuthResponse.getEmail();
        User foundUser = userRepository.getUserByEmail(userEmail);
        if (foundUser == null) {
            return new LoginResponseDto(null, googleOAuthResponse.getEmail(), null, null);
        }
        String jwtToken = jwtTokenProvider.createToken(foundUser.getEmail(), foundUser.getRoleList());
        return new LoginResponseDto(foundUser.getId(), foundUser.getEmail(), foundUser.getNickname(), jwtToken);
    }

    public LoginResponseDto signup(SignupRequestDto signupRequestDto) {

        ResponseEntity<?> response = this.checkToken(signupRequestDto.getAccess_token());
        if (response.getStatusCode() == HttpStatus.UNAUTHORIZED) {
            throw new HttpClientErrorException(HttpStatus.UNAUTHORIZED, "유효하지 않은 토큰입니다.");
        }

        if (userRepository.getUserByEmail(signupRequestDto.getEmail()) != null) {
            throw new DataIntegrityViolationException("이미 존재하는 이메일입니다.");
        }

        if (userRepository.getUserByNickname(signupRequestDto.getNickname()) != null) {
            throw new DataIntegrityViolationException("이미 존재하는 닉네임입니다.");
        }

        User newUser = new User();
        newUser.setEmail(signupRequestDto.getEmail());
        newUser.setNickname(signupRequestDto.getNickname());
        newUser.setRoles("ROLE_USER");
        newUser.setIsActive(true);
        User savedUser = userRepository.save(newUser);
        String jwtToken = jwtTokenProvider.createToken(savedUser.getEmail(), savedUser.getRoleList());
        return new LoginResponseDto(savedUser.getId(), savedUser.getEmail(), savedUser.getNickname(), jwtToken);
    }

    public ResponseEntity<?> checkToken(String access_token) {
        String GOOGLE_USERINFO_REQUEST_URL = "https://www.googleapis.com/oauth2/v1/userinfo";
        try {
            WebClient webClient = WebClient.builder()
                    .baseUrl(GOOGLE_USERINFO_REQUEST_URL)
                    .defaultHeader("Authorization", "Bearer " + access_token)
                    .build();
            GoogleOAuthResponseDto res = webClient.get().retrieve().bodyToMono(GoogleOAuthResponseDto.class).block();
            return ResponseEntity.status(HttpStatus.OK).body(res);
        } catch (HttpClientErrorException e) {
            return ResponseEntity.status(e.getStatusCode()).body(e.getMessage());
        }
        catch (WebClientResponseException e) {
            return ResponseEntity.status(e.getStatusCode()).body(e.getMessage());
        }
    }

    public void deleteUser(Long user_idx) {
        userRepository.deleteById(user_idx);
    }

    public String changeUserNickname(Long user_idx, String nickname) {
        User foundUser = userRepository.getUserById(user_idx);
        foundUser.setNickname(nickname);
        return userRepository.save(foundUser).getNickname();
    }


}
