package org.study.project05;

import org.study.project05.common.badword.BadWordFiltering;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

    /**
     * 한국어 욕설 필터 Bean
     * ReviewServiceImpl에서 @Autowired로 주입받아 사용
     */
    @Bean
    public BadWordFiltering badWordFiltering() {
        return new BadWordFiltering();
    }
}