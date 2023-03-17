package com.cocook.service;

import com.cocook.dto.db.ThemeResDto;
import com.cocook.entity.Theme;
import com.cocook.repository.ThemeRepository;
import com.cocook.util.S3Uploader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@Service
public class ThemeService {

    private final ThemeRepository themeRepository;
    private final S3Uploader s3Uploader;

    @Autowired
    public ThemeService(ThemeRepository themeRepository, S3Uploader s3Uploader) {
        this.themeRepository = themeRepository;
        this.s3Uploader = s3Uploader;
    }

    public ThemeResDto makeTheme (String themeName, MultipartFile themeImg) {

        String storedFilePath;
        try {
            storedFilePath = s3Uploader.upload(themeImg,"images");
        } catch (IOException e) {
            throw new RuntimeException(e.getMessage());
        }

        Theme theme = new Theme();
        theme.setThemeName(themeName);
        theme.setImgPath(storedFilePath);
        Theme newTheme = themeRepository.save(theme);
        return new ThemeResDto(newTheme.getThemeName());
    }
}
