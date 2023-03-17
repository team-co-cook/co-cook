package com.cocook.dto.favorite;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotNull;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AddFavoriteReqDto {

    @NotNull(message = "레시피 idx가 비어있습니다.")
    private Long recipeIdx;

}
