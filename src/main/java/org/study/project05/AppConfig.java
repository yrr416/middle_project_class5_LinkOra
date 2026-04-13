package org.study.project05;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.study.project05.common.badword.BadWordFiltering;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

    @Bean
    public ObjectMapper objectMapper() {
        return new ObjectMapper();
    }

    @Bean
    public BadWordFiltering badWordFiltering() {
        return new BadWordFiltering();
    }
}
