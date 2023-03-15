package com.cocook.repository;

import com.cocook.entity.Theme;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ThemeRepository extends JpaRepository<Theme, Long> {
    Theme getThemeByThemeName(String themeName);

    List<Theme> findAll();
}
