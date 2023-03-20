package com.cocook.dto.list;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipeListResDto {

    List<RecipeDetailResDto> recipeListResDto;

}
