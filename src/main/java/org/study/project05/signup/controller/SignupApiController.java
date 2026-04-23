/**
 * 회원가입 보조 API: 아이디 중복 여부 조회(GET).
 */
package org.study.project05.signup.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.signup.service.PartnerSignupService;
import org.study.project05.signup.service.SignupEmailVerificationService;

import java.util.Locale;
import java.util.Map;

@RestController
@RequestMapping("/api/signup")
public class SignupApiController {

    private static final int MAX_USER_ID_LEN = 64;
    private static final int MAX_EMAIL_LEN = 128;

    private final UserProfileService userProfileService;
    private final PartnerSignupService partnerSignupService;
    private final SignupEmailVerificationService signupEmailVerificationService;

    public SignupApiController(
            UserProfileService userProfileService,
            PartnerSignupService partnerSignupService,
            SignupEmailVerificationService signupEmailVerificationService
    ) {
        this.userProfileService = userProfileService;
        this.partnerSignupService = partnerSignupService;
        this.signupEmailVerificationService = signupEmailVerificationService;
    }

    /**
     * 일반·사업자 테이블을 함께 조회해 로그인 아이디 충돌 여부를 반환합니다.
     *
     * @return {@code available}, {@code message}
     */
    @GetMapping("/check-user-id")
    public Map<String, Object> checkUserId(@RequestParam(value = "userId", required = false) String userId) {
        String id = normalizeUserId(userId);
        if (id.isEmpty()) {
            return Map.of("available", false, "message", "아이디를 입력해 주세요.");
        }
        if (id.length() > MAX_USER_ID_LEN) {
            return Map.of("available", false, "message", "아이디는 " + MAX_USER_ID_LEN + "자 이하여야 합니다.");
        }
        boolean taken;
        try {
            taken = userProfileService.existsUserId(id) || partnerSignupService.existsPartnerId(id);
        } catch (Exception e) {
            return Map.of("available", false, "message", "중복 확인에 실패했습니다. 잠시 후 다시 시도해 주세요.");
        }
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
        String em = normalizeEmail(email);
        if (em.isEmpty()) {
            return Map.of("available", false, "message", "이메일을 입력해 주세요.");
        }
        if (!em.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return Map.of("available", false, "message", "올바른 이메일 형식이 아닙니다.");
        }
        if (em.length() > MAX_EMAIL_LEN) {
            return Map.of("available", false, "message", "이메일은 " + MAX_EMAIL_LEN + "자 이하여야 합니다.");
        }
        boolean taken;
        try {
            taken = userProfileService.existsEmail(em) || partnerSignupService.existsPartnerEmail(em);
        } catch (Exception e) {
            return Map.of("available", false, "message", "중복 확인에 실패했습니다. 잠시 후 다시 시도해 주세요.");
        }
        if (taken) {
            return Map.of("available", false, "message", "이미 사용 중인 이메일입니다.");
        }
        return Map.of("available", true, "message", "사용 가능한 이메일입니다.");
    }

    @PostMapping("/send-email-code")
    public Map<String, Object> sendEmailCode(
            @RequestParam(value = "email", required = false) String email,
            HttpSession session
    ) {
        String em = normalizeEmail(email);
        if (em.isEmpty() || !em.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return Map.of("success", false, "message", "올바른 이메일 형식이 아닙니다.");
        }
        if (em.length() > MAX_EMAIL_LEN) {
            return Map.of("success", false, "message", "이메일은 " + MAX_EMAIL_LEN + "자 이하여야 합니다.");
        }
        try {
            boolean taken = userProfileService.existsEmail(em) || partnerSignupService.existsPartnerEmail(em);
            if (taken) {
                return Map.of("success", false, "message", "이미 사용 중인 이메일입니다.");
            }
        } catch (Exception e) {
            return Map.of("success", false, "message", "중복 확인에 실패했습니다. 잠시 후 다시 시도해 주세요.");
        }

        SignupEmailVerificationService.SendResult result = signupEmailVerificationService.sendCode(session, em);
        return switch (result) {
            case SUCCESS -> Map.of("success", true, "message", "인증번호를 이메일로 보냈습니다.");
            case INVALID_EMAIL -> Map.of("success", false, "message", "올바른 이메일 형식이 아닙니다.");
            case COOLDOWN -> Map.of(
                    "success", false,
                    "message", "재요청은 잠시 후 가능합니다.",
                    "cooldownSeconds", signupEmailVerificationService.getSendCooldownRemainingSeconds(session)
            );
            case MAIL_CONFIG_ERROR -> Map.of("success", false, "message", "메일 설정이 올바르지 않습니다.");
            case MAIL_PROVIDER_ERROR -> Map.of("success", false, "message", "메일 발송 제공자 설정을 확인해 주세요.");
            default -> Map.of("success", false, "message", "인증번호 발송에 실패했습니다. 잠시 후 다시 시도해 주세요.");
        };
    }

    @PostMapping("/verify-email-code")
    public Map<String, Object> verifyEmailCode(
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "code", required = false) String code,
            HttpSession session
    ) {
        SignupEmailVerificationService.VerifyResult result =
                signupEmailVerificationService.verifyCode(session, email, code);
        return switch (result) {
            case SUCCESS -> Map.of("success", true, "message", "이메일 인증이 완료되었습니다.");
            case EXPIRED -> Map.of("success", false, "message", "인증번호가 만료되었습니다. 다시 요청해 주세요.");
            case NOT_MATCHED -> Map.of("success", false, "message", "인증번호가 일치하지 않습니다.");
            case LOCKED -> Map.of("success", false, "message", "인증번호 입력 3회 실패로 잠겼습니다. 인증번호를 다시 받아주세요.");
            case INVALID_REQUEST -> Map.of("success", false, "message", "인증 요청 정보가 없습니다. 인증번호를 다시 받아주세요.");
            default -> Map.of("success", false, "message", "인증 처리에 실패했습니다.");
        };
    }

    private static String normalizeUserId(String userId) {
        return userId == null ? "" : userId.trim();
    }

    private static String normalizeEmail(String email) {
        if (email == null) return "";
        String trimmed = email.trim();
        return trimmed.isEmpty() ? "" : trimmed.toLowerCase(Locale.ROOT);
    }
}
