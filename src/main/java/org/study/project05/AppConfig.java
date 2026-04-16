package org.study.project05;

import org.study.project05.common.badword.BadWordFiltering;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

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

    // 토스페이먼츠 승인 API 호출에 사용 (PaymentServiceImpl에서 주입받음)
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}