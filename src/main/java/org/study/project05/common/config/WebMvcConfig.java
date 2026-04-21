/**
 * MVC 설정: 프로필 업로드 디렉터리를 /static/upload/profiles 로 노출, JSP용 document root 지정.
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

    @Value("${app.upload.profiles-dir:src/main/webapp/static/upload/profiles}")
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
                .excludePathPatterns("/static/**", "/assets/**", "/error", "/favicon.ico");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // [전체 업로드 디렉터리] /static/upload/** → webapp/static/upload/ 파일시스템 절대 경로
        // toUri().toString() 사용으로 Windows에서 올바른 file:///D:/... 형식 생성
        Path uploadsDir = Paths.get("src/main/webapp/static/upload").toAbsolutePath().normalize();
        String uploadsLocation = uploadsDir.toUri().toString();

        registry.addResourceHandler("/static/upload/**")
                .addResourceLocations(uploadsLocation);

        // [프로필 이미지] /uploads/profiles/** 별칭 유지 (하위 호환)
        Path profilesPath = Paths.get(profilesDir).toAbsolutePath().normalize();
        registry.addResourceHandler("/uploads/profiles/**")
                .addResourceLocations(profilesPath.toUri().toString());

        // webapp/static/ 하위 정적 리소스 서빙 (css, js, img 등)
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/");

        // [assets] /assets/** 매핑
        Path assetsPath = Paths.get("assets").toAbsolutePath().normalize();
        registry.addResourceHandler("/assets/**")
                .addResourceLocations(assetsPath.toUri().toString());

        // [Favicon]
        registry.addResourceHandler("/favicon.ico")
                .addResourceLocations("classpath:/static/");
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
