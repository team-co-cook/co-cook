package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.user.GoogleOAuthResponseDto;
import com.cocook.dto.user.LoginResponseDto;
import com.cocook.dto.user.SignupRequestDto;
import com.cocook.entity.User;
import com.cocook.repository.UserRepository;
import lombok.AllArgsConstructor;

import org.hibernate.ObjectNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import javax.persistence.EntityNotFoundException;

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
            throw new AuthenticationServiceException("유효하지 않은 토큰입니다.");
        }
        GoogleOAuthResponseDto googleOAuthResponse = (GoogleOAuthResponseDto) response.getBody();

        String userEmail = googleOAuthResponse.getEmail();
        User foundUser = userRepository.findByEmailAndIsActiveTrue(userEmail);
        if (foundUser == null) {
            return new LoginResponseDto(null, googleOAuthResponse.getEmail(), null, null);
        }
        String jwtToken = jwtTokenProvider.createToken(foundUser.getId(), foundUser.getRoleList());
        return new LoginResponseDto(foundUser.getId(), foundUser.getEmail(), foundUser.getNickname(), jwtToken);
    }

    public LoginResponseDto signup(SignupRequestDto signupRequestDto) {

        ResponseEntity<?> response = this.checkToken(signupRequestDto.getAccess_token());
        if (response.getStatusCode() == HttpStatus.UNAUTHORIZED) {
            throw new AuthenticationServiceException("유효하지 않은 토큰입니다.");
        }

        if (userRepository.findByNickname(signupRequestDto.getNickname()) != null) {
            throw new DataIntegrityViolationException("이미 존재하는 닉네임입니다.");
        }

        User foundUser = userRepository.findByEmail(signupRequestDto.getEmail());
        if (foundUser != null) {
            if (foundUser.getIsActive()) {
                throw new DataIntegrityViolationException("이미 존재하는 이메일입니다.");
            } else {
                foundUser.setIsActive(true);
                foundUser.setEmail(signupRequestDto.getEmail());
                foundUser.setNickname(signupRequestDto.getNickname());
                User savedUser = userRepository.save(foundUser);
                String jwtToken = jwtTokenProvider.createToken(savedUser.getId(), savedUser.getRoleList());
                return new LoginResponseDto(savedUser.getId(), savedUser.getEmail(), savedUser.getNickname(), jwtToken);
            }
        }

        User newUser = new User();
        newUser.setEmail(signupRequestDto.getEmail());
        newUser.setNickname(signupRequestDto.getNickname());
        if (newUser.getNickname().equals("admin")) {
            newUser.setRoles("ROLE_ADMIN");
        } else {
            newUser.setRoles("ROLE_USER");
        }
        newUser.setIsActive(true);
        User savedUser = userRepository.save(newUser);
        String jwtToken = jwtTokenProvider.createToken(savedUser.getId(), savedUser.getRoleList());
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
        } catch (WebClientResponseException e) {
            return ResponseEntity.status(e.getStatusCode()).body(e.getMessage());
        }
    }

    public void deleteUser(Long user_idx) {
        User foundUser = userRepository.findByIdAndIsActiveTrue(user_idx);
        if (foundUser == null) {
            throw new EntityNotFoundException("존재하지 않는 유저입니다.");
        }
        foundUser.setIsActive(false);
        userRepository.save(foundUser);
    }

    public String changeUserNickname(Long user_idx, String nickname) {
        User foundUser = userRepository.findByIdAndIsActiveTrue(user_idx);
        if (foundUser == null) {
            throw new EntityNotFoundException("존재하지 않는 유저입니다.");
        }
        if (userRepository.findByNickname(nickname) != null) {
            throw new DataIntegrityViolationException("이미 존재하는 닉네임입니다.");
        }
        foundUser.setNickname(nickname);
        return userRepository.save(foundUser).getNickname();
    }


}
