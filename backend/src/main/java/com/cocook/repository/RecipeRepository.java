package com.cocook.repository;

import com.cocook.entity.Recipe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RecipeRepository extends JpaRepository<Recipe, Long> {

    List<Recipe> findByTags_Theme_ThemeName(String themeName);

    @Query(value = "select * from recipe order by rand() limit 6", nativeQuery = true)
    List<Recipe> findRandomRecipes();

}
