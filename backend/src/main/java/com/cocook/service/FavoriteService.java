package com.cocook.service;

import com.cocook.auth.JwtTokenProvider;
import com.cocook.dto.favorite.AddFavoriteReqDto;
import com.cocook.entity.Favorite;
import com.cocook.entity.Recipe;
import com.cocook.entity.User;
import com.cocook.repository.FavoriteRepository;
import com.cocook.repository.RecipeRepository;
import com.cocook.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import javax.persistence.EntityNotFoundException;
import java.util.Optional;

@Service
public class FavoriteService {

    private final JwtTokenProvider jwtTokenProvider;
    private final FavoriteRepository favoriteRepository;
    private final UserRepository userRepository;
    private final RecipeRepository recipeRepository;

    @Autowired
    public FavoriteService(JwtTokenProvider jwtTokenProvider, FavoriteRepository favoriteRepository, UserRepository userRepository, RecipeRepository recipeRepository) {
        this.jwtTokenProvider = jwtTokenProvider;
        this.favoriteRepository = favoriteRepository;
        this.userRepository = userRepository;
        this.recipeRepository = recipeRepository;
    }

    public void addFavorite(String authToken, AddFavoriteReqDto addFavoriteReqDto) {
        Long recipeIdx = addFavoriteReqDto.getRecipeIdx();
        Optional<Recipe> foundRecipe = recipeRepository.findById(recipeIdx);
        if (foundRecipe.isEmpty()) {
            throw new EntityNotFoundException("해당 레시피가 존재하지 않습니다.");
        }

        Long userIdx = jwtTokenProvider.getUserIdx(authToken);
        if (favoriteRepository.findByUserIdAndRecipeId(userIdx, recipeIdx) != null) {
            throw new DataIntegrityViolationException("이미 해당 유저가 찜한 레시피입니다.");
        }
        User foundUser = userRepository.findByIdAndIsActiveTrue(userIdx);

        Favorite favorite = new Favorite();
        favorite.setUser(foundUser);
        favorite.setRecipe(foundRecipe.get());
        favoriteRepository.save(favorite);
    }

    public void deleteFavorite(String authToken, Long recipeIdx) {
        Optional<Recipe> foundRecipe = recipeRepository.findById(recipeIdx);
        if (foundRecipe.isEmpty()) {
            throw new EntityNotFoundException("해당 레시피가 존재하지 않습니다.");
        }

        Long userIdx = jwtTokenProvider.getUserIdx(authToken);

        Favorite foundFavorite = favoriteRepository.findByUserIdAndRecipeId(userIdx, recipeIdx);
        if (foundFavorite == null) {
            throw new DataIntegrityViolationException("아직 해당 유저가 찜하지 않은 레시피입니다.");
        }

        favoriteRepository.delete(foundFavorite);
    }

}
