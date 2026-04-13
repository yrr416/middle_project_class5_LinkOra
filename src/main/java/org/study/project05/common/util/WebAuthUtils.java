/**
 * 웹 인증 보조: 익명 사용자 여부, 역할(ROLE_*) 확인, 세션 무효화 포함 로그아웃.
 */
package org.study.project05.common.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;

public final class WebAuthUtils {

    private WebAuthUtils() {
    }

    public static boolean isAnonymous(Authentication authentication) {
        return authentication == null
                || !authentication.isAuthenticated()
                || authentication instanceof AnonymousAuthenticationToken
                || "anonymousUser".equals(authentication.getName());
    }

    public static boolean hasRole(Authentication authentication, String role) {
        if (authentication == null || role == null) {
            return false;
        }
        for (GrantedAuthority authority : authentication.getAuthorities()) {
            if (role.equals(authority.getAuthority())) {
                return true;
            }
        }
        return false;
    }

    public static void performLogout(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication
    ) {
        new SecurityContextLogoutHandler().logout(request, response, authentication);
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
