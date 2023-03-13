package com.cocook.service;

import com.cocook.dto.db.ThemeReqDto;
import com.cocook.dto.db.ThemeResDto;
import com.cocook.entity.Theme;
import com.cocook.repository.ThemeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ThemeService {

    private ThemeRepository themeRepository;

    @Autowired
    public ThemeService(ThemeRepository themeRepository) {
        this.themeRepository = themeRepository;
    }

    public ThemeResDto makeTheme (ThemeReqDto themeReqDto) {
        Theme theme = new Theme();
        theme.setThemeName(themeReqDto.getThemeName());
        theme.setImgPath(themeReqDto.getThemeImgPath());
        Theme newTheme = themeRepository.save(theme);
        return new ThemeResDto(newTheme.getThemeName());
    }
}
