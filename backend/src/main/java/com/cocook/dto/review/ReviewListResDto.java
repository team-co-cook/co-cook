package com.cocook.dto.review;

import com.cocook.entity.Review;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class ReviewListResDto {
    List<ReviewResDto> reviewsListResDto;
}
