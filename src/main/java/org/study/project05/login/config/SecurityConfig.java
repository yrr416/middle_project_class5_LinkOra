/**
 * Spring Security: 요청 허용 정책, 폼 로그인(/perform_login), 로그아웃, PasswordEncoder 빈.
 */
package org.study.project05.login.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.servlet.util.matcher.PathPatternRequestMatcher;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())  // CSRF 비활성화 — JSP 폼 POST 요청이 403으로 막히는 문제 해결
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll()
                )
                .formLogin(form -> form
                        .loginPage("/loginPage")
                        .loginProcessingUrl("/perform_login")
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .successHandler((request, response, authentication) -> {
                            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
                            jakarta.servlet.http.HttpSession session = request.getSession();

                            boolean isPartner = authentication.getAuthorities().stream()
                                    .anyMatch(authority -> "ROLE_PARTNER".equals(authority.getAuthority()));

                            if (isPartner) {
                                session.setAttribute("partnerIdx", userDetails.getIdx());
                                session.setAttribute("userIdx", userDetails.getIdx()); // 호환성 유지
                            } else {
                                session.setAttribute("userIdx", userDetails.getIdx());
                            }
                            
                            session.setAttribute("userName", userDetails.getRealName());

                            String target = isPartner ? "/partner/mypage" : "/";
                            response.sendRedirect(request.getContextPath() + target);
                        })
                        .failureUrl("/loginPage?error")
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutRequestMatcher(PathPatternRequestMatcher.pathPattern("/logout"))
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .deleteCookies("JSESSIONID")
                );

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        PasswordEncoder delegating = PasswordEncoderFactories.createDelegatingPasswordEncoder();
        PasswordEncoder bcrypt = new BCryptPasswordEncoder();

        return new PasswordEncoder() {
            @Override
            public String encode(CharSequence rawPassword) {
                return delegating.encode(rawPassword);
            }

            @Override
            public boolean matches(CharSequence rawPassword, String encodedPassword) {
                if (rawPassword == null || encodedPassword == null) {
                    return false;
                }

                if (encodedPassword.startsWith("{")) {
                    return delegating.matches(rawPassword, encodedPassword);
                }

                if (encodedPassword.startsWith("$2a$")
                        || encodedPassword.startsWith("$2b$")
                        || encodedPassword.startsWith("$2y$")) {
                    return bcrypt.matches(rawPassword, encodedPassword);
                }

                return delegating.matches(rawPassword, "{noop}" + encodedPassword);
            }

            @Override
            public boolean upgradeEncoding(String encodedPassword) {
                return delegating.upgradeEncoding(encodedPassword);
            }
        };
    }
}
