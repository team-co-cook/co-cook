package com.cocook.config;

import com.github.jfasttext.JFastText;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;

@Configuration
public class AppConfig {

    @Bean
    public JFastText fastText() throws IOException {
        // FastText 모델 파일 경로
        String modelPath = "src/main/resources/wiki.ko.bin";

        // FastText 모델 로드
        JFastText fastText = new JFastText();
        fastText.loadModel(modelPath);
        return fastText;
    }

}
