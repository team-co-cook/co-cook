package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.recipe.RecipeListResDto;
import com.cocook.dto.review.MyReview;
import com.cocook.dto.review.MyReviewResDto;
import com.cocook.dto.review.ReviewReqDto;
import com.cocook.dto.review.ReviewResDto;
import com.cocook.dto.user.GoogleOAuthResponseDto;
import com.cocook.dto.user.LoginResponseDto;
import com.cocook.dto.user.SignupRequestDto;
import com.cocook.entity.Favorite;
import com.cocook.entity.Recipe;
import com.cocook.entity.Review;
import com.cocook.entity.User;
import com.cocook.repository.FavoriteRepository;
import com.cocook.repository.RecipeRepository;
import com.cocook.repository.ReviewRepository;
import com.cocook.repository.UserRepository;
import lombok.AllArgsConstructor;

import org.hibernate.ObjectNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import javax.persistence.EntityNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service
@AllArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final JwtTokenProvider jwtTokenProvider;
    private final ReviewRepository reviewRepository;
    private RecipeRepository recipeRepository;
    private FavoriteRepository favoriteRepository;
    private RedisTemplate<String, String> redisTemplate;

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

    public List<MyReviewResDto> getReviews(String token) {
        Long foundUserIdx = jwtTokenProvider.getUserIdx(token);
        List<MyReview> reviews = reviewRepository.findReviewsByUserIdOrderByIdDesc(foundUserIdx);
        List<MyReviewResDto> myReviewResDtos = new ArrayList<>();
        for (MyReview review : reviews) {
            boolean isLiked;
            isLiked = review.getIsLiked() == 1;
            MyReviewResDto myReviewResDto = MyReviewResDto.builder()
                    .reviewIdx(review.getReviewIdx())
                    .content(review.getContent())
                    .likeCnt(review.getLikeCnt())
                    .runningTime(review.getRunningTime())
                    .userIdx(review.getUserIdx())
                    .createdAt(review.getCreatedAt())
                    .userNickname(review.getUserNickname())
                    .imgPath(review.getImgPath())
                    .isLiked(isLiked)
                    .commentCnt(review.getCommentCnt())
                    .recipeIdx(review.getRecipeIdx()).build();
            myReviewResDtos.add(myReviewResDto);
        }
        return myReviewResDtos;
    }

    public List<RecipeListResDto> getRecentRecipe(String authToken) {
        Long userIdx = jwtTokenProvider.getUserIdx(authToken);
        ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
        Long length = zSetOperations.size(userIdx.toString());
        if (length == null) {
            return new ArrayList<>();
        }
        Set<String> idxList = zSetOperations.reverseRange(userIdx.toString(), 0, -1);
        List<RecipeListResDto> recipeListResDtoList = new ArrayList<>();
        for (String stringIdx : idxList) {
            Recipe recipe = recipeRepository.findRecipeById(Long.parseLong(stringIdx));
            if (recipe == null) {
                continue;
            }
            Favorite favorite = favoriteRepository.findByUserIdAndRecipeId(userIdx, recipe.getId());
            boolean isFavorite = favorite != null;
            RecipeListResDto recipeListResDto = RecipeListResDto.builder()
                    .recipeName(recipe.getRecipeName())
                    .recipeDifficulty(recipe.getDifficulty())
                    .recipeIdx(recipe.getId())
                    .recipeImgPath(recipe.getImgPath())
                    .recipeRunningTime(recipe.getRunningTime())
                    .isFavorite(isFavorite)
                    .build();
            recipeListResDtoList.add(recipeListResDto);
        }
        return recipeListResDtoList;
    }

}
