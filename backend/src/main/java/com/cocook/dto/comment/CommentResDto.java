package com.cocook.dto.comment;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
@Data
@AllArgsConstructor
@Builder
public class CommentResDto {

    private Long commentIdx;

    private Long userIdx;

    private LocalDateTime createdAt;

    private String userNickname;

    private String content;

    private Integer reportCnt;
}
