/**
 * 카카오 로그인: OAuth 인가 URL 이동, 콜백(/kakaologin)에서 토큰·프로필 처리 후 사이트 로그인까지 연결.
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
import org.study.project05.login.util.KakaoUtil;
import org.study.project05.login.vo.KakaoUserVO;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.member.vo.UserProfileVO;

import java.nio.charset.StandardCharsets;

@Controller
public class KakaoAuthController {

    private static final String KAKAO_AUTH = "https://kauth.kakao.com/oauth/authorize";
    private final KakaoUtil kakaoUtil;
    private final UserProfileService userProfileService;
    private final SocialLoginCompletionService socialLoginCompletionService;

    public KakaoAuthController(
            KakaoUtil kakaoUtil,
            UserProfileService userProfileService,
            SocialLoginCompletionService socialLoginCompletionService
    ) {
        this.kakaoUtil = kakaoUtil;
        this.userProfileService = userProfileService;
        this.socialLoginCompletionService = socialLoginCompletionService;
    }

    @Value("${kakao.client-id:}")
    private String clientId;

    @Value("${kakao.redirect-uri:http://localhost:8080/kakaologin}")
    private String redirectUri;

    @GetMapping("/kakao/authorize")
    public String kakaoAuthorize() {
        if (clientId == null || clientId.isBlank()) {
            return "redirect:/loginPage?error=kakao_config";
        }
        String url = UriComponentsBuilder.fromUriString(KAKAO_AUTH)
                .queryParam("client_id", clientId)
                .queryParam("redirect_uri", redirectUri)
                .queryParam("response_type", "code")
                .queryParam("prompt", "login")
                .queryParam("scope", "profile_nickname,account_email,phone_number")
                .encode(StandardCharsets.UTF_8)
                .build()
                .toUriString();
        return "redirect:" + url;
    }

    @GetMapping("/kakaologin")
    public String kakaologin(
            @RequestParam(value = "code", required = false) String code,
            @RequestParam(value = "error", required = false) String error,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session
    ) {
        if (error != null) {
            return "redirect:/loginPage?error=kakao_denied";
        }
        if (code == null || code.isBlank()) {
            return "redirect:/loginPage?error=kakao_no_code";
        }
        try {
            String accessToken = kakaoUtil.getAccessToken(code);
            if (accessToken == null || accessToken.isBlank()) {
                return "redirect:/loginPage?error=kakao_token";
            }
            KakaoUserVO user = kakaoUtil.getUserProfile(accessToken);
            if (user == null || user.getId() == null || user.getId().isBlank()) {
                return "redirect:/loginPage?error=kakao_profile";
            }
            String phone = PhoneNumberUtil.normalizeKoreanMobile(user.getPhoneNumber());
            String address = mergeKakaoAddress(user.getBaseAddress(), user.getDetailAddress());

            String siteUserId = userProfileService.upsertOAuthUser(
                    "kakao",
                    user.getId(),
                    user.getNickname(),
                    user.getEmail(),
                    address,
                    phone,
                    user.getThumbnailImageUrl()
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
            e.printStackTrace();
            return "redirect:/loginPage?error=kakao_fail";
        }
    }

    private static String mergeKakaoAddress(String base, String detail) {
        if (base == null) {
            base = "";
        }
        if (detail == null) {
            detail = "";
        }
        if (base.isEmpty() && detail.isEmpty()) {
            return "";
        }
        if (detail.isBlank()) {
            return base;
        }
        if (base.isEmpty()) {
            return detail.trim();
        }
        return (base + " " + detail).trim();
    }
}
