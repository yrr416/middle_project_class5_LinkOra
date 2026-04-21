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

    @Value("${app.upload.notice-dir:src/main/webapp/static/upload/notice}")
    private String noticeDir;

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
        // [프로필 이미지] file: 접두사 사용하여 절대 경로 매핑 (Windows 환경 안정성 확보)
        Path dir = Paths.get(profilesDir).toAbsolutePath().normalize();
        String location = "file:" + dir.toString().replace("\\", "/") + "/";
        
        registry.addResourceHandler("/static/upload/profiles/**")
                .addResourceLocations(location);

        registry.addResourceHandler("/uploads/profiles/**")
                .addResourceLocations(location);

        // [공지사항 이미지]
        Path noticeImgDir = Paths.get(noticeDir).toAbsolutePath().normalize();
        String noticeLocation = "file:" + noticeImgDir.toString().replace("\\", "/") + "/";
        
        registry.addResourceHandler("/static/upload/notice/**")
                .addResourceLocations(noticeLocation);

        // [통합 정적 리소스] /static/** 하위 모든 요청(branch, review 등) 처리
        Path staticDir = Paths.get("src", "main", "webapp", "static").toAbsolutePath().normalize();
        String staticLocation = "file:" + staticDir.toString().replace("\\", "/") + "/";
        
        registry.addResourceHandler("/static/**")
                .addResourceLocations(staticLocation);
        
        // [추가] /assets/** 매핑 (기존 StaticResourceConfig 대체)
        Path assetsPath = Paths.get("assets").toAbsolutePath().normalize();
        String assetsLocation = "file:" + assetsPath.toString().replace("\\", "/") + "/";
        registry.addResourceHandler("/assets/**")
                .addResourceLocations(assetsLocation);

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
