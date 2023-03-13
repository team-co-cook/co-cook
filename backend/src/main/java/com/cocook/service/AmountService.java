package com.cocook.service;

import com.cocook.entity.Amount;
import com.cocook.entity.Ingredient;
import com.cocook.entity.Recipe;
import com.cocook.repository.AmountRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AmountService {
    @Autowired
    private AmountRepository amountRepository;

    public void makeAmount(Recipe recipe, Ingredient ingredient, String content) {
        Amount amount = new Amount();
        amount.setRecipe(recipe);
        amount.setIngredient(ingredient);
        amount.setContent(content);
        amountRepository.save(amount);
    }
}
