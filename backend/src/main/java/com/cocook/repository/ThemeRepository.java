package com.cocook.repository;

import com.cocook.entity.Theme;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ThemeRepository extends JpaRepository<Theme, Long> {
    Theme getThemeByThemeName(String themeName);

    @Query(value = "SELECT th.theme_idx FROM theme th " +
            "JOIN tag t ON t.theme_idx = th.theme_idx " +
            "JOIN recipe r ON t.recipe_idx = r.recipe_idx " +
            "WHERE r.recipe_idx = :recipeIdx ;", nativeQuery = true)
    List<Long> findThemesIdxByRecipeIdx(@Param("recipeIdx") Long recipeIdx);

    List<Theme> findAll();

    @Query("SELECT t FROM Theme t where t.themeName NOT IN (:themeNames)")
    List<Theme> findThemesNotInThemeNames(@Param("themeNames") List<String> themeNames);

}
