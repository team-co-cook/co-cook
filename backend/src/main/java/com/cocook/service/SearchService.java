package com.cocook.service;

import lombok.AllArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ZSetOperations;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service
@AllArgsConstructor
public class SearchService {

    private RedisTemplate<String, String> redisTemplate;

    public List<String> getPopularKeywords() {
        ZSetOperations<String, String> zSetOperations = redisTemplate.opsForZSet();
        Set<String> popularKeywords = zSetOperations.reverseRange("searchHistorySet",0, 9);
        if (popularKeywords == null) {
            return new ArrayList<>();
        }
        return new ArrayList<>(popularKeywords);
    }

}
