/**
 * Spring Boot 애플리케이션 진입점(메인) 및 하위 패키지 컴포넌트 스캔 루트.
 */
package org.study.project05;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.mybatis.spring.annotation.MapperScan;

@SpringBootApplication(scanBasePackages = "org.study.project05")
@MapperScan(basePackages = {
        "org.study.project05.member.mapper",
        "org.study.project05.partner.mapper",
        "org.study.project05.branch.mapper",
        "org.study.project05.mainpage.mapper",
        "org.study.project05.map.mapper"
})
public class Project05Application {

    public static void main(String[] args) {
        SpringApplication.run(Project05Application.class, args);
    }

}
