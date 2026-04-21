package org.study.project05.common.config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.boot.web.server.servlet.ConfigurableServletWebServerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.File;
import java.nio.file.Paths;

/**
 * 내장 Tomcat(로컬 개발) 전용 설정.
 * 외부 Tomcat(WAR 배포)에서는 ConfigurableServletWebServerFactory 클래스가 없으므로
 * @ConditionalOnClass 로 조건부 활성화하여 ClassNotFoundException 방지.
 */
@Configuration
@ConditionalOnClass(name = "org.springframework.boot.web.server.servlet.ConfigurableServletWebServerFactory")
public class EmbeddedServerConfig {

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
