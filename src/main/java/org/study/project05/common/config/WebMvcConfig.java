/**
 * MVC 설정: 프로필 업로드 디렉터리를 /uploads/profiles 로 노출, JSP용 document root 지정.
 */
package org.study.project05.common.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.boot.web.server.servlet.ConfigurableServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.study.project05.common.interceptor.SessionSyncInterceptor;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${app.upload.profiles-dir:uploads/profiles}")
    private String profilesDir;

    private final SessionSyncInterceptor sessionSyncInterceptor;

    @Autowired
    public WebMvcConfig(SessionSyncInterceptor sessionSyncInterceptor) {
        this.sessionSyncInterceptor = sessionSyncInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(sessionSyncInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/static/**", "/assets/**", "/uploads/**", "/error", "/favicon.ico");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path dir = Paths.get(profilesDir).toAbsolutePath().normalize();
        String location = dir.toUri().toString();
        if (!location.endsWith("/")) {
            location += "/";
        }
        // 기존 DB에 /uploads/profiles/** 경로로 저장된 이미지 호환 서빙
        registry.addResourceHandler("/uploads/profiles/**")
                .addResourceLocations(location);

        // 기존 DB에 /uploads/notice/** 경로로 저장된 이미지 호환 서빙
        Path noticeImgDir = Paths.get("src", "main", "webapp", "static", "upload", "notice").toAbsolutePath().normalize();
        String noticeLocation = noticeImgDir.toUri().toString();
        if (!noticeLocation.endsWith("/")) noticeLocation += "/";
        registry.addResourceHandler("/uploads/notice/**")
                .addResourceLocations(noticeLocation);

        // webapp/static/ 하위 업로드 이미지 서빙 (branch, review, notice, video 등)
        Path staticDir = Paths.get("src", "main", "webapp", "static").toAbsolutePath().normalize();
        String staticLocation = staticDir.toUri().toString();
        if (!staticLocation.endsWith("/")) staticLocation += "/";
        registry.addResourceHandler("/static/**")
                .addResourceLocations(staticLocation);
    }

    @Bean
    public WebServerFactoryCustomizer<ConfigurableServletWebServerFactory> webappDocumentRootCustomizer() {
        return factory -> {
            File webapp = Paths.get("src", "main", "webapp").toFile();
            if (webapp.isDirectory()) {
                factory.setDocumentRoot(webapp);
            }
        };
    }
}
