/**
 * 정적 리소스 매핑: /assets 및 /uploads 요청을 로컬 폴더로 연결.
 */
package org.study.project05.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class StaticResourceConfig implements WebMvcConfigurer {

    private final String assetsLocation;
    private final String uploadsLocation;

    public StaticResourceConfig(
            @Value("${app.assets-dir:assets}") String assetsDir,
            @Value("${app.uploads-dir:uploads}") String uploadsDir) {

        // assets 폴더 경로 설정
        Path dir = Paths.get(assetsDir).toAbsolutePath().normalize();
        this.assetsLocation = dir.toUri().toString();

        // [수정] 웹앱 내부 경로 src/main/webapp/uploads 등을 정확히 시스템 절대 경로로 변환
        Path upDir = Paths.get(uploadsDir).toAbsolutePath().normalize();
        String upLoc = upDir.toUri().toString();
        // 경로가 반드시 /로 끝나도록 설정하여 하위 파일을 잘 찾게 함
        this.uploadsLocation = upLoc.endsWith("/") ? upLoc : upLoc + "/";
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // /assets/** 요청 처리
        registry.addResourceHandler("/assets/**")
                .addResourceLocations(assetsLocation);

        // /static/upload/** 요청 처리
        registry.addResourceHandler("/static/upload/**")
                .addResourceLocations(uploadsLocation);

        // 브라우저 favicon 404 에러 방지
        registry.addResourceHandler("/favicon.ico")
                .addResourceLocations("classpath:/static/");
    }
}