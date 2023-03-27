package com.cocook.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.File;

@Configuration
public class AppConfig {
    @Bean
    public File word2VecModelFile() {
        return new File("src/main/resources/ko.bin");
    }
}
