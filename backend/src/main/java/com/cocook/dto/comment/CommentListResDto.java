package com.cocook.dto.comment;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;
@Data
@AllArgsConstructor
public class CommentListResDto {
    List<CommentResDto> commentResDto;
}
