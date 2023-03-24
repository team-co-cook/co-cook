package com.cocook.repository;

import com.cocook.dto.list.RecipesContainingIngredientsCnt;
import com.cocook.entity.Recipe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RecipeRepository extends JpaRepository<Recipe, Long> {

    Recipe findRecipeById(Long id);
    List<Recipe> findByTags_Theme_ThemeName(String themeName);
    @Query(value = "SELECT * FROM recipe r " +
            "JOIN tag t ON t.recipe_idx = r.recipe_idx " +
            "JOIN theme th ON t.theme_idx = th.theme_idx " +
            "WHERE th.theme_name = :themeName " +
            "ORDER BY RAND() LIMIT 5;", nativeQuery = true)
    List<Recipe> findRandom5RecipesByThemeName(@Param("themeName") String themeName);

    @Query(value = "SELECT * FROM recipe ORDER BY RAND() limit 6", nativeQuery = true)
    List<Recipe> findRandomRecipes();

    @Query(value = "SELECT * FROM recipe r " +
                "JOIN tag t ON t.recipe_idx = r.recipe_idx " +
                "JOIN theme th ON t.theme_idx = th.theme_idx " +
                "WHERE th.theme_name = :themeName " +
                "ORDER BY r.recipe_idx DESC;", nativeQuery = true)
    List<Recipe> findByThemeNameOrderByIdDesc(@Param("themeName") String themeName);

    List<Recipe> findByCategoryCategoryNameOrderByIdDesc(String categoryName);

    List<Recipe> findAllByOrderByIdDesc();

    List<Recipe> findByRecipeNameContainingOrderByIdDesc(String keyword);

    @Query("SELECT r FROM Recipe r JOIN r.favorites f WHERE f.user.id = :userId")
    List<Recipe> findRecipesByUserId(@Param("userId") Long userId);


    @Query(value = "SELECT r.recipe_idx as recipeIdx, r.recipe_name as recipeName, r.img_path as recipeImgPath," +
            " r.difficulty as recipeDifficulty, r.running_time as recipeRunningTime, " +
            "EXISTS(SELECT 1 FROM favorite WHERE user_idx = :userIdx AND recipe_idx = r.recipe_idx) as isFavorite, " +
            "(SELECT COUNT(*) from amount a WHERE a.recipe_idx = r.recipe_idx) AS totalIngredientCnt, " +
            "COUNT(*) AS includingIngredientCnt FROM recipe r " +
            "JOIN amount a ON a.recipe_idx = r.recipe_idx " +
            "JOIN ingredient i on i.ingredient_idx = a.ingredient_idx " +
            "WHERE i.ingredient_name IN (:ingredientNames) " +
            "GROUP BY r.recipe_idx " +
            "ORDER BY includingIngredientCnt DESC;", nativeQuery = true)
    List<RecipesContainingIngredientsCnt> findRecipesByIngredients(@Param("ingredientNames") List<String> ingredientNames,
                                                                   @Param("userIdx") Long userIdx);

    @Query(value = "SELECT DISTINCT * FROM recipe r JOIN amount a ON a.recipe_idx = r.recipe_idx " +
            "JOIN ingredient i ON i.ingredient_idx = a.ingredient_idx " +
            "WHERE i.ingredient_name IN (:ingredientNames);", nativeQuery = true)
    List<Recipe> findByIngredients(@Param("ingredientNames") List<String> ingredientNames);

}
