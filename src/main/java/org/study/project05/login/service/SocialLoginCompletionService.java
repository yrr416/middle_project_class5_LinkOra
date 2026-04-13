/**
 * 소셜 로그인 후 사이트 사용자명으로 Spring Security 세션 인증을 완료하기 위한 계약.
 */
package org.study.project05.login.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public interface SocialLoginCompletionService {
    void signIn(HttpServletRequest request, HttpServletResponse response, String username);
}
