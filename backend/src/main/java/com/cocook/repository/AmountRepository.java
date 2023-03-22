package com.cocook.repository;

import com.cocook.entity.Amount;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AmountRepository extends JpaRepository<Amount, Long> {

    List<Amount> findAmountsByRecipeId(Long recipeIdx);

}
