package org.study.project05.common.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.study.project05.login.config.CustomUserDetails;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.member.vo.UserProfileVO;

/**
 * 전역 세션 동기화 인터셉터:
 * 스프링 시큐리티 인증 정보가 존재하지만 세션 정보(userIdx, loginUser)가 누락된 경우를 방지하기 위해
 * 매 요청마다 세션을 자동으로 동기화하여 서비스의 안정성을 보장합니다.
 */
@Component
@RequiredArgsConstructor
public class SessionSyncInterceptor implements HandlerInterceptor {

    private final UserProfileService userProfileService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        // 1. 인증 정보가 존재하고 익명이 아닌 경우에만 동기화 시도
        if (auth != null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken)) {
            HttpSession session = request.getSession();
            

            // 2. 세션 필수 정보가 하나라도 없는 경우 동기화 실행
            // 파트너는 loginUser 세션을 사용하지 않으므로, partnerIdx가 있으면 동기화 건너뜀

            // 2. 세션 필수 정보가 하나라도 없는 경우 동기화 실행
            // 파트너는 loginUser 세션을 사용하지 않으므로, partnerIdx가 있으면 동기화 건너뜀

            boolean isPartner = session.getAttribute("partnerIdx") != null;
            if (!isPartner && (session.getAttribute("userIdx") == null || session.getAttribute("loginUser") == null)) {
                Object principal = auth.getPrincipal();
                
                if (principal instanceof CustomUserDetails userDetails) {
                    // [Case 1] CustomUserDetails가 확보된 경우 (일반/소셜 로그인 표준)
                    syncSession(session, userDetails.getIdx(), userDetails.getRealName(), userDetails.getUsername());
                } else {
                    // [Case 2] 기타 인증 객체인 경우 (하위 호환성용 DB 재조회)
                    String username = auth.getName();
                    UserProfileVO user = userProfileService.getByUserId(username);
                    if (user != null) {
                        syncSession(session, (long) user.getUserIdx(), user.getName(), user.getUserId());
                    }
                }
            }
        }
        
        return true;
    }

    private void syncSession(HttpSession session, Long idx, String realName, String userId) {
        // 이미 세션에 데이터가 있는지 한 번 더 체크 (최신화 필요 시 덮어쓰기 가능)
        session.setAttribute("userIdx", idx);
        session.setAttribute("userName", realName);
        
        // 기존 기능(리뷰, 상세페이지 등) 호환성을 위한 loginUser 객체 유지
        if (session.getAttribute("loginUser") == null) {
            UserProfileVO vo = userProfileService.getByUserId(userId);
            if (vo != null) {
                vo.setPassword(null); // 보안 강화
                session.setAttribute("loginUser", vo);
            }
        }
    }
}
