package com.cocook.repository;

import com.cocook.dto.list.RecipesContainingIngredientsCnt;
import com.cocook.dto.recipe.RecipeIdx;
import com.cocook.entity.Recipe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Arrays;
import java.util.List;

public interface RecipeRepository extends JpaRepository<Recipe, Long> {

    Recipe findRecipeById(Long id);

    @Query(value = "SELECT r.recipe_idx FROM recipe r " +
            "JOIN tag t ON t.recipe_idx = r.recipe_idx " +
            "JOIN theme th ON t.theme_idx = th.theme_idx " +
            "WHERE th.theme_name = :themeName ;", nativeQuery = true)
    List<Long> findByTheme(@Param("themeName") String themeName);
//    List<Recipe> findByTags_Theme_ThemeName(String themeName);
//    @Query(value = "SELECT * FROM recipe r " +
//            "JOIN tag t ON t.recipe_idx = r.recipe_idx " +
//            "JOIN theme th ON t.theme_idx = th.theme_idx " +
//            "WHERE th.theme_name = :themeName " +
//            "ORDER BY RAND() LIMIT 5;", nativeQuery = true)
//    List<Recipe> findRandom5RecipesByThemeName(@Param("themeName") String themeName);

    @Query(value = "SELECT * FROM recipe " +
            "JOIN review ON review.recipe_idx = recipe.recipe_idx " +
            "WHERE review.created_date > DATE_ADD(NOW(), INTERVAL -7 DAY) AND " +
            "recipe.recipe_idx IN (:recipeIdxList) AND " +
            "recipe.recipe_idx in (" +
            "   SELECT recipe.recipe_idx " +
            "   FROM recipe " +
            "   JOIN category ON category.category_idx = recipe.category_idx " +
            "   WHERE category.category_name = '메인 요리')" +
            "GROUP BY review.recipe_idx " +
            "ORDER BY COUNT(*) DESC LIMIT 1;", nativeQuery = true)
    Recipe findRecipeByRecentReview(@Param("recipeIdxList") List<Long> recipeIdxList);

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

    @Query(value = "SELECT r.recipe_idx FROM recipe r " +
            "JOIN favorite f ON f.recipe_idx = r.recipe_idx " +
            "JOIN user u ON u.user_idx = f.user_idx " +
            "WHERE u.user_idx = :userIdx " +
            "ORDER BY f.favorite_idx DESC LIMIT 1;", nativeQuery = true)
    Recipe findByUserCurrentFavorite(@Param("userIdx") Long userIdx);

    @Query(value = "SELECT *, COUNT(*) FROM recipe recommend_recipe " +
            "JOIN tag t ON recommend_recipe.recipe_idx = t.recipe_idx " +
            "JOIN (SELECT th.theme_idx, COUNT(*) FROM theme th " +
            "JOIN tag t ON t.theme_idx = th.theme_idx " +
            "JOIN (SELECT r.recipe_idx FROM recipe r " +
            "JOIN favorite f ON f.recipe_idx = r.recipe_idx " +
            "JOIN user u ON u.user_idx = f.user_idx " +
            "WHERE f.user_idx = :userIdx " +
            "ORDER BY f.favorite_idx LIMIT 3) " +
            "AS favorite_recipes ON t.recipe_idx = favorite_recipes.recipe_idx " +
            "WHERE th.theme_name NOT IN ('아침', '점심', '저녁', '야식') " +
            "GROUP BY th.theme_idx " +
            "ORDER BY COUNT(*) DESC, RAND() LIMIT 2) " +
            "AS favorite_theme ON favorite_theme.theme_idx = t.theme_idx " +
            "WHERE recommend_recipe.recipe_idx IN (:recipeIdxList) AND " +
            "recommend_recipe.recipe_idx IN (" +
            "   SELECT recipe.recipe_idx " +
            "   FROM recipe " +
            "   JOIN category ON category.category_idx = recipe.category_idx " +
            "   WHERE category.category_name = '메인 요리')" +
            "GROUP BY recommend_recipe.recipe_idx " +
            "ORDER BY COUNT(*) DESC, RAND() LIMIT :quota ;", nativeQuery = true)
    List<Recipe> findRecommendRecipeByUserIdx(@Param("userIdx") Long userIdx, @Param("recipeIdxList") List<Long> recipeIdxList, @Param("quota") Integer quota);

    @Query(value = "SELECT * " +
            "FROM recipe r " +
            "WHERE r.recipe_idx IN " +
            "(SELECT * FROM ( " +
            "    SELECT recipe_idx " +
            "    FROM favorite  " +
            "    WHERE created_date > DATE_ADD(NOW(), INTERVAL -7 DAY) AND " +
            "    recipe_idx IN :recipeIdxList AND " +
            "    recipe_idx IN (" +
            "        SELECT recipe.recipe_idx " +
            "        FROM recipe " +
            "        JOIN category ON category.category_idx = recipe.category_idx " +
            "        WHERE category.category_name = '메인 요리')" +
            "    GROUP BY recipe_idx " +
            "    ORDER BY COUNT(*) DESC, RAND() LIMIT :quota " +
            ") AS TMP) ;", nativeQuery = true)
    List<Recipe> findRecipeByRecentFavorite(@Param("recipeIdxList") List<Long> recipeIdxList, @Param("quota") Integer quota);

    List<Recipe> findByIdIn(List<Long> pickList);

    @Query(value = "SELECT r.recipe_idx as recipeIdx, r.recipe_name as recipeName, r.img_path as recipeImgPath," +
            " r.difficulty as recipeDifficulty, r.running_time as recipeRunningTime, " +
            "EXISTS(SELECT 1 FROM favorite WHERE user_idx = :userIdx AND recipe_idx = r.recipe_idx) as isFavorite, " +
            "(SELECT COUNT(*) from amount a WHERE a.recipe_idx = r.recipe_idx) AS totalIngredientCnt, " +
            "COUNT(*) AS includingIngredientCnt FROM recipe r " +
            "JOIN amount a ON a.recipe_idx = r.recipe_idx " +
            "JOIN ingredient i on i.ingredient_idx = a.ingredient_idx " +
            "WHERE i.ingredient_name IN (:ingredientNames) " +
            "OR i.search_keyword IN (:ingredientNames) " +
            "GROUP BY r.recipe_idx " +
            "ORDER BY includingIngredientCnt DESC;", nativeQuery = true)
    List<RecipesContainingIngredientsCnt> findRecipesByIngredients(@Param("ingredientNames") List<String> ingredientNames,
                                                                   @Param("userIdx") Long userIdx);

    @Query(value = "SELECT DISTINCT * FROM recipe r JOIN amount a ON a.recipe_idx = r.recipe_idx " +
            "JOIN ingredient i ON i.ingredient_idx = a.ingredient_idx " +
            "WHERE i.ingredient_name IN (:ingredientNames);", nativeQuery = true)
    List<Recipe> findByIngredients(@Param("ingredientNames") List<String> ingredientNames);

}
