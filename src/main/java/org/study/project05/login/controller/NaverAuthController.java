/**
 * 네이버 로그인: OAuth 인가(state 포함), 콜백(/naverlogin)에서 토큰·프로필 처리 후 사이트 로그인까지 연결.
 */
package org.study.project05.login.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriComponentsBuilder;
import org.study.project05.common.util.PhoneNumberUtil;
import org.study.project05.login.service.SocialLoginCompletionService;
import org.study.project05.login.util.NaverUtil;
import org.study.project05.login.vo.NaverUserVO;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.member.vo.UserProfileVO;

import java.nio.charset.StandardCharsets;
import java.util.UUID;

@Controller
public class NaverAuthController {

    private static final String SESSION_NAVER_STATE = "NAVER_OAUTH_STATE";

    private static final String NAVER_AUTH = "https://nid.naver.com/oauth2.0/authorize";

    private final NaverUtil naverUtil;
    private final UserProfileService userProfileService;
    private final SocialLoginCompletionService socialLoginCompletionService;

    @Value("${naver.client-id:}")
    private String clientId;

    @Value("${naver.redirect-uri:http://localhost:8080/naverlogin}")
    private String redirectUri;

    public NaverAuthController(
            NaverUtil naverUtil,
            UserProfileService userProfileService,
            SocialLoginCompletionService socialLoginCompletionService
    ) {
        this.naverUtil = naverUtil;
        this.userProfileService = userProfileService;
        this.socialLoginCompletionService = socialLoginCompletionService;
    }

    @GetMapping("/naver/authorize")
    public String naverAuthorize(HttpSession session) {
        if (clientId == null || clientId.isBlank()) {
            return "redirect:/loginPage?error=naver_config";
        }
        String state = UUID.randomUUID().toString();
        session.setAttribute(SESSION_NAVER_STATE, state);

        String url = UriComponentsBuilder.fromUriString(NAVER_AUTH)
                .queryParam("response_type", "code")
                .queryParam("client_id", clientId)
                .queryParam("redirect_uri", redirectUri)
                .queryParam("state", state)
                .queryParam("auth_type", "reprompt")
                .encode(StandardCharsets.UTF_8)
                .build()
                .toUriString();
        return "redirect:" + url;
    }

    @GetMapping("/naverlogin")
    public String naverlogin(
            @RequestParam(value = "code", required = false) String code,
            @RequestParam(value = "state", required = false) String state,
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "error_description", required = false) String errorDescription,
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response
    ) {
        if (error != null) {
            session.removeAttribute(SESSION_NAVER_STATE);
            return "redirect:/loginPage?error=naver_denied";
        }
        String savedState = (String) session.getAttribute(SESSION_NAVER_STATE);
        session.removeAttribute(SESSION_NAVER_STATE);
        if (savedState == null || state == null || !savedState.equals(state)) {
            return "redirect:/loginPage?error=naver_state";
        }
        if (code == null || code.isBlank()) {
            return "redirect:/loginPage?error=naver_no_code";
        }
        try {
            String accessToken = naverUtil.getAccessToken(code, state);
            if (accessToken == null || accessToken.isBlank()) {
                return "redirect:/loginPage?error=naver_token";
            }

            NaverUserVO user = naverUtil.getUserProfile(accessToken);
            if (user == null || user.getId() == null) {
                return "redirect:/loginPage?error=naver_profile";
            }

            String phone = PhoneNumberUtil.normalizeKoreanMobile(
                    user.getMobile() != null ? user.getMobile() : "");
            String siteUserId = userProfileService.upsertOAuthUser(
                    "naver",
                    user.getId(),
                    user.getName(),
                    user.getEmail(),
                    "",
                    phone,
                    user.getProfileImage()
            );
            socialLoginCompletionService.signIn(request, response, siteUserId);

            // 소셜 로그인 후 loginUser 세션 설정 (리뷰/예약 등 다른 기능에서 사용)
            UserProfileVO loginUser = userProfileService.getByUserId(siteUserId);
            if (loginUser != null) {
                loginUser.setPassword(null);
                session.setAttribute("loginUser", loginUser);
            }

            return "redirect:/mypage";
        } catch (Exception e) {
            return "redirect:/loginPage?error=naver_fail";
        }
    }
}
