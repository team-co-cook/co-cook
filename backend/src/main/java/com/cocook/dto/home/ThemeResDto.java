package com.cocook.dto.home;

import com.cocook.entity.Theme;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class ThemeResDto {

    private List<Theme> themes;

}
