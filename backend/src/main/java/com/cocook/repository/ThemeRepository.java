package com.cocook.repository;

import com.cocook.entity.Theme;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ThemeRepository extends JpaRepository<Theme, Long> {
    Theme getThemeByThemeName(String themeName);

    List<Theme> findAll();

    @Query("SELECT t FROM Theme t where t.themeName NOT IN (:themeNames)")
    List<Theme> findThemesNotInThemeNames(@Param("themeNames") List<String> themeNames);

}
