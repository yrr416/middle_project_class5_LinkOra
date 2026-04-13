/**
 * 정적 리소스 매핑: /assets 요청을 로컬 assets 폴더로 연결.
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

    public StaticResourceConfig(@Value("${app.assets-dir:assets}") String assetsDir) {
        Path dir = Paths.get(assetsDir).toAbsolutePath().normalize();
        String location = dir.toUri().toString();
        this.assetsLocation = location.endsWith("/") ? location : location + "/";
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/assets/**")
                .addResourceLocations(assetsLocation);
    }
}
