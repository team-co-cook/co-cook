package com.cocook.repository;

import com.cocook.entity.Ingredient;
import org.springframework.data.jpa.repository.JpaRepository;

public interface IngredientRepository extends JpaRepository<Ingredient, Long> {
    Ingredient getIngredientByIngredientName(String ingredientName);
}
