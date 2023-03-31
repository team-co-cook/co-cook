package com.cocook.service;

import com.cocook.dto.db.IngredientReqDto;
import com.cocook.entity.Ingredient;
import com.cocook.repository.IngredientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class IngredientService {

    private IngredientRepository ingredientRepository;

    @Autowired
    public IngredientService(IngredientRepository ingredientRepository) {this.ingredientRepository = ingredientRepository;}

    public Ingredient getIngredient(IngredientReqDto ingredientReqDto) {
        Ingredient ingredient = ingredientRepository.getIngredientByIngredientName(ingredientReqDto.getIngredientName());
        if (ingredient == null) {
            ingredient = new Ingredient();
            ingredient.setIngredientName(ingredientReqDto.getIngredientName());
            ingredient = ingredientRepository.save(ingredient);
        }
        return ingredient;
    }

    public List<Ingredient> checkIngredient(String ingredientName) {
        return ingredientRepository.findIngredientsBySearchKeyword(ingredientName);
    }
}
