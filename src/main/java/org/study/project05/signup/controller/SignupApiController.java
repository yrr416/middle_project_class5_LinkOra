/**
 * 회원가입 보조 API: 아이디 중복 여부 조회(GET).
 */
package org.study.project05.signup.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.signup.service.PartnerSignupService;

import java.util.Map;

@RestController
@RequestMapping("/api/signup")
public class SignupApiController {

    private static final int MAX_USER_ID_LEN = 64;
    private static final int MAX_EMAIL_LEN = 128;

    private final UserProfileService userProfileService;
    private final PartnerSignupService partnerSignupService;

    public SignupApiController(
            UserProfileService userProfileService,
            PartnerSignupService partnerSignupService
    ) {
        this.userProfileService = userProfileService;
        this.partnerSignupService = partnerSignupService;
    }

    /**
     * 일반·사업자 테이블을 함께 조회해 로그인 아이디 충돌 여부를 반환합니다.
     *
     * @return {@code available}, {@code message}
     */
    @GetMapping("/check-user-id")
    public Map<String, Object> checkUserId(@RequestParam(value = "userId", required = false) String userId) {
        String id = userId == null ? "" : userId.trim();
        if (id.isEmpty()) {
            return Map.of("available", false, "message", "아이디를 입력해 주세요.");
        }
        if (id.length() > MAX_USER_ID_LEN) {
            return Map.of("available", false, "message", "아이디는 " + MAX_USER_ID_LEN + "자 이하여야 합니다.");
        }
        boolean taken = userProfileService.existsUserId(id) || partnerSignupService.existsPartnerId(id);
        if (taken) {
            return Map.of("available", false, "message", "이미 사용 중인 아이디입니다.");
        }
        return Map.of("available", true, "message", "사용 가능한 아이디입니다.");
    }

    /**
     * 일반·사업자 테이블을 함께 조회해 이메일 충돌 여부를 반환합니다.
     */
    @GetMapping("/check-email")
    public Map<String, Object> checkEmail(@RequestParam(value = "email", required = false) String email) {
        String em = email == null ? "" : email.trim();
        if (em.isEmpty()) {
            return Map.of("available", false, "message", "이메일을 입력해 주세요.");
        }
        if (!em.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return Map.of("available", false, "message", "올바른 이메일 형식이 아닙니다.");
        }
        if (em.length() > MAX_EMAIL_LEN) {
            return Map.of("available", false, "message", "이메일은 " + MAX_EMAIL_LEN + "자 이하여야 합니다.");
        }
        boolean taken = userProfileService.existsEmail(em) || partnerSignupService.existsPartnerEmail(em);
        if (taken) {
            return Map.of("available", false, "message", "이미 사용 중인 이메일입니다.");
        }
        return Map.of("available", true, "message", "사용 가능한 이메일입니다.");
    }
}
