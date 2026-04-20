package org.study.project05.login.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * 폼 로그인 POST에서 username/password 앞뒤 공백 제거(메일·클립보드 복사 대응).
 */
public class LoginFormParameterTrimFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {
        if (!"POST".equalsIgnoreCase(request.getMethod()) || !isPerformLoginRequest(request)) {
            filterChain.doFilter(request, response);
            return;
        }
        filterChain.doFilter(new HttpServletRequestWrapper(request) {
            @Override
            public String[] getParameterValues(String name) {
                String[] raw = super.getParameterValues(name);
                if (raw == null) {
                    return null;
                }
                if (!"username".equals(name) && !"password".equals(name)) {
                    return raw;
                }
                String[] trimmed = new String[raw.length];
                for (int i = 0; i < raw.length; i++) {
                    trimmed[i] = raw[i] == null ? null : raw[i].strip();
                }
                return trimmed;
            }
        }, response);
    }

    private static boolean isPerformLoginRequest(HttpServletRequest request) {
        if ("/perform_login".equals(request.getServletPath())) {
            return true;
        }
        String uri = request.getRequestURI();
        String ctx = request.getContextPath() != null ? request.getContextPath() : "";
        if (uri != null && uri.startsWith(ctx)) {
            String rel = uri.substring(ctx.length());
            while (rel.endsWith("/") && rel.length() > 1) {
                rel = rel.substring(0, rel.length() - 1);
            }
            if ("/perform_login".equals(rel)) {
                return true;
            }
        }
        return uri != null && uri.endsWith("/perform_login");
    }
}
