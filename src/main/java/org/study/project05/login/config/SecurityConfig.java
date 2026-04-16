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
                .csrf(csrf -> csrf
                        // [추가] 자바스크립트로 POST 요청을 보내는 찜하기 API(/api/wishlist/**)에서 403 에러가 나지 않도록 CSRF 검사 예외 처리 추가
                        .ignoringRequestMatchers("/chat/**", "/api/wishlist/**")
                )
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

                            boolean isAdmin = authentication.getAuthorities().stream()
                                    .anyMatch(authority -> "ROLE_ADMIN".equals(authority.getAuthority()));
                            boolean isPartner = authentication.getAuthorities().stream()
                                    .anyMatch(authority -> "ROLE_PARTNER".equals(authority.getAuthority()));

                            if (isAdmin) {
                                session.setAttribute("userIdx", userDetails.getIdx());
                                session.setAttribute("isAdmin", true);
                            } else if (isPartner) {
                                session.setAttribute("partnerIdx", userDetails.getIdx());
                                session.setAttribute("userIdx", userDetails.getIdx()); // 호환성 유지
                            } else {
                                session.setAttribute("userIdx", userDetails.getIdx());
                            }

                            session.setAttribute("userName", userDetails.getRealName());

                            // [추가] 문의 기능 한정: 로그인 전 목적지가 있었다면 해당 페이지로 리다이렉트
                            String prevUrl = (String) session.getAttribute("prevUrl");
                            if (prevUrl != null && prevUrl.startsWith("/inquiry")) {
                                session.removeAttribute("prevUrl");
                                response.sendRedirect(request.getContextPath() + prevUrl);
                                return;
                            }

                            String target = isAdmin ? "/admin/dashboard" : isPartner ? "/partner/mypage" : "/";
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