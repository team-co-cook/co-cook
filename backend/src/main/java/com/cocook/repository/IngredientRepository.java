package com.cocook.repository;

import com.cocook.entity.Ingredient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface IngredientRepository extends JpaRepository<Ingredient, Long> {
    Ingredient getIngredientByIngredientName(String ingredientName);

    @Query(value = "SELECT * FROM ingredient i " +
            "JOIN amount a ON a.ingredient_idx = i.ingredient_idx " +
            "JOIN recipe r ON a.recipe_idx = r.recipe_idx " +
            "WHERE r.recipe_idx = :recipeIdx ", nativeQuery = true)
    List<Ingredient> findIngredientsByRecipeIdx(@Param("recipeIdx") Long recipeIdx);
}
