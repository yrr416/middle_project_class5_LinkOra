/**
 * MVC 설정: 프로필 업로드 디렉터리를 /static/upload/profiles 로 노출, JSP용 document root 지정.
 */
package org.study.project05.common.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.study.project05.common.interceptor.SessionSyncInterceptor;

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

        // [공지사항 이미지] 파일시스템(런타임 업로드) 먼저 탐색, 없으면 WAR 내부로 폴백
        // WAR 배포 시 커밋된 이미지는 파일시스템에 없으므로 /static/ 폴백이 필수
        Path noticeImgDir = Paths.get(noticeDir).toAbsolutePath().normalize();
        String noticeLocation = "file:" + noticeImgDir.toString().replace("\\", "/") + "/";

        registry.addResourceHandler("/static/upload/notice/**")
                .addResourceLocations(noticeLocation, "/static/upload/notice/");

        // webapp/static/ 하위 이미지 서빙 (branch, review 등) - WAR 내부 웹루트 경로 사용
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/");

        // [추가] /assets/** 매핑 (기존 StaticResourceConfig 대체)
        Path assetsPath = Paths.get("assets").toAbsolutePath().normalize();
        String assetsLocation = "file:" + assetsPath.toString().replace("\\", "/") + "/";
        registry.addResourceHandler("/assets/**")
                .addResourceLocations(assetsLocation);

        // [Favicon]
        registry.addResourceHandler("/favicon.ico")
                .addResourceLocations("classpath:/static/");
    }

}
