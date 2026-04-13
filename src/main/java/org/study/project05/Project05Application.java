/**
 * Spring Boot 애플리케이션 진입점(메인) 및 하위 패키지 컴포넌트 스캔 루트.
 */
package org.study.project05;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

// @Mapper 어노테이션만으로 Spring Bean 자동 등록됨 (mybatis-spring-boot-starter 자동설정)
// @MapperScan 불필요
@EnableScheduling  // 스케줄러 기능 ON — 이게 있어야 @Scheduled 어노테이션이 동작함
@SpringBootApplication(scanBasePackages = "org.study.project05")
public class Project05Application {

    public static void main(String[] args) {
        SpringApplication.run(Project05Application.class, args);
    }

}
