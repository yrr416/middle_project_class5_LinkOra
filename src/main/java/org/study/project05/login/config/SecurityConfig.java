/**
 * Spring Security: 요청 허용 정책, 폼 로그인(/perform_login), 로그아웃, PasswordEncoder 빈.
 */
package org.study.project05.login.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.http.HttpMethod;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.servlet.util.matcher.PathPatternRequestMatcher;
import org.springframework.security.core.userdetails.UserDetailsService;

@Configuration
public class SecurityConfig {

    private static final Logger log = LoggerFactory.getLogger(SecurityConfig.class);

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
                String stored = encodedPassword.strip();
                String presented = rawPassword.toString().strip();

                if (stored.startsWith("{")) {
                    return delegating.matches(presented, stored);
                }

                if (stored.startsWith("$2a$")
                        || stored.startsWith("$2b$")
                        || stored.startsWith("$2y$")) {
                    return bcrypt.matches(presented, stored);
                }

                return delegating.matches(presented, "{noop}" + stored);
            }

            @Override
            public boolean upgradeEncoding(String encodedPassword) {
                return delegating.upgradeEncoding(encodedPassword);
            }
        };
    }

    /**
     * 폼 로그인이 항상 아래 {@link PasswordEncoder}·{@link UserDetailsService} 조합만 쓰도록 단일 프로바이더로 고정한다.
     * (Security 7 + 자동 구성에서 인코더가 어긋나 임시 비밀번호 검증이 실패하는 경우를 막음)
     */
    @Bean
    public AuthenticationManager authenticationManager(
            UserDetailsService userDetailsService,
            PasswordEncoder passwordEncoder
    ) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider(userDetailsService);
        provider.setPasswordEncoder(passwordEncoder);
        return new ProviderManager(provider);
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, AuthenticationManager authenticationManager)
            throws Exception {
        http
                .authenticationManager(authenticationManager)
                .addFilterBefore(new LoginFormParameterTrimFilter(), UsernamePasswordAuthenticationFilter.class)
                .csrf(csrf -> csrf
                        // [추가] 자바스크립트로 POST 요청을 보내는 찜하기 API(/api/wishlist/**)에서 403 에러가 나지 않도록 CSRF 검사 예외 처리 추가
                        .ignoringRequestMatchers("/chat/**", "/api/wishlist/**", "/admin/reservation/**")
                )
                .authorizeHttpRequests(auth -> auth
                        // 관리자 전용 경로 - ROLE_ADMIN만 접근 허용
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .anyRequest().permitAll()
                )
                .formLogin(form -> form
                        .loginPage("/loginPage")
                        .loginProcessingUrl("/perform_login")
                        .usernameParameter("username")
                        .passwordParameter("password")
                        .successHandler((request, response, authentication) -> {
                            jakarta.servlet.http.HttpSession session = request.getSession();

                            boolean isAdmin = authentication.getAuthorities().stream()
                                    .anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));
                            boolean isPartner = authentication.getAuthorities().stream()
                                    .anyMatch(authority -> "ROLE_PARTNER".equals(authority.getAuthority()));

                            // instanceof 패턴으로 안전하게 캐스팅 (DevTools 핫리로드 시 ClassCastException 방지)
                            if (authentication.getPrincipal() instanceof CustomUserDetails userDetails) {
                                if (isAdmin) {
                                    session.setAttribute("userIdx", userDetails.getIdx());
                                    session.setAttribute("isAdmin", true); // SSH 추가: 관리자 여부 세션에 저장
                                } else if (isPartner) {
                                    session.setAttribute("partnerIdx", userDetails.getIdx());
                                    session.setAttribute("userIdx", userDetails.getIdx());
                                } else {
                                    session.setAttribute("userIdx", userDetails.getIdx());
                                }
                                session.setAttribute("userName", userDetails.getRealName());
                            }

                            // 관리자는 바로 대시보드로
                            if (isAdmin) {
                                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                                return;
                            }

                            // 문의 기능 한정: 로그인 전 목적지가 있었다면 해당 페이지로 리다이렉트
                            String prevUrl = (String) session.getAttribute("prevUrl");
                            if (prevUrl != null && prevUrl.startsWith("/inquiry")) {
                                session.removeAttribute("prevUrl");
                                response.sendRedirect(request.getContextPath() + prevUrl);
                                return;
                            }

                            String target = isAdmin ? "/admin/dashboard" : isPartner ? "/partner/mypage" : "/";
                            response.sendRedirect(request.getContextPath() + target);
                        })
                        .failureHandler((request, response, exception) -> {
                            String errorCode = "auth";
                            // DaoAuthenticationProvider가 loadUserByUsername의 DisabledException을
                            // InternalAuthenticationServiceException으로 감싸 전달하는 경우가 있음
                            if (containsInChain(exception, DisabledException.class)) {
                                errorCode = "inactive";
                            } else {
                                log.warn("로그인 실패: {}", exception.toString());
                            }
                            response.sendRedirect(request.getContextPath() + "/loginPage?error=" + errorCode);
                        })
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutRequestMatcher(PathPatternRequestMatcher.pathPattern(HttpMethod.GET, "/logout"))
                        .logoutSuccessUrl("/")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .deleteCookies("JSESSIONID")
                );

        return http.build();
    }

    private static boolean containsInChain(Throwable throwable, Class<? extends Throwable> type) {
        for (Throwable t = throwable; t != null; t = t.getCause()) {
            if (type.isInstance(t)) {
                return true;
            }
        }
        return false;
    }
}
