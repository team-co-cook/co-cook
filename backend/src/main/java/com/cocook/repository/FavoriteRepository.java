package com.cocook.repository;

import com.cocook.entity.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FavoriteRepository extends JpaRepository<Favorite, Long> {

    Favorite findByUserIdAndRecipeId(Long userId, Long recipeId);

}
