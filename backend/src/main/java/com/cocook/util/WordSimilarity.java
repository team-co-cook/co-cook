package com.cocook.util;

import com.github.jfasttext.JFastText;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WordSimilarity {
    public double getCosineSimilarity(JFastText fastText, List<Float> vec1, String word2) {
        List<Float> vec2 = fastText.getVector(word2);

        double dotProduct = 0.0;
        double norm1 = 0.0;
        double norm2 = 0.0;

        for (int i = 0; i < vec1.size(); i++) {
            dotProduct += vec1.get(i) * vec2.get(i);
            norm1 += vec1.get(i) * vec1.get(i);
            norm2 += vec2.get(i) * vec2.get(i);
        }

        return dotProduct / (Math.sqrt(norm1) * Math.sqrt(norm2));
    }
}
