package com.on_bapsang.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class WebClientConfig {
    @Bean
    public WebClient aiWebClient() {
        return WebClient.builder()
                .baseUrl("http://bapsang-ai:8000")
                .build();
    }
}
