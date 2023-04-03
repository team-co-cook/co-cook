package com.cocook.dto.home;

import com.cocook.entity.Theme;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
@Builder
public class ThemeResDto {

    private Long id;
    private String themeName;
    private String imgPath;

}
