package com.cocook.config;

import org.deeplearning4j.models.embeddings.loader.WordVectorSerializer;
import org.deeplearning4j.models.word2vec.StaticWord2Vec;
import org.deeplearning4j.models.word2vec.Word2Vec;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

@Configuration
public class AppConfig {
    @Value("classpath:ko.bin")
    private Resource resource;

    @Bean
    public Word2Vec word2Vec() throws IOException {
        Resource resource = new ClassPathResource("ko.bin");
        InputStream inputStream = resource.getInputStream();
        Word2Vec word2Vec = (Word2Vec) WordVectorSerializer.loadStaticModel(inputStream);
        return word2Vec;
    }
}
