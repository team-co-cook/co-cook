package com.cocook.repository;

import com.cocook.entity.Amount;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AmountRepository extends JpaRepository<Amount, Long> {
    Amount findAmountByRecipeIdAndIngredientId(Long recipeId, Long ingredientId);
}
