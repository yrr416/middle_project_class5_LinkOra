/**
 * 로그인·계정 찾기 화면: 로그인 페이지, 아이디/비밀번호 찾기 폼 처리, 즉시 로그아웃(/logoutNow).
 */
package org.study.project05.login.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.study.project05.common.util.WebAuthUtils;
import org.study.project05.member.service.PasswordResetMailService;
import org.study.project05.member.service.UserProfileService;

@Controller
public class LoginWebController {

    private static final Logger log = LoggerFactory.getLogger(LoginWebController.class);

    private final UserProfileService userProfileService;
    private final PasswordResetMailService passwordResetMailService;

    public LoginWebController(UserProfileService userProfileService, PasswordResetMailService passwordResetMailService) {
        this.userProfileService = userProfileService;
        this.passwordResetMailService = passwordResetMailService;
    }

    @GetMapping("/loginPage")
    public String loginPage() {
        return "auth/login";
    }

    @GetMapping("/forgot-password")
    public String forgotPasswordPage() {
        return "auth/forgot-password";
    }

    @GetMapping("/forgot-id")
    public String forgotIdPage() {
        return "auth/forgot-id";
    }

    @PostMapping("/forgot-id")
    public String forgotIdSubmit(@RequestParam("email") String email) {
        UserProfileService.UserIdFindIssueResult result = userProfileService.issueUserIdByEmail(email);
        if (result.result() == UserProfileService.UserIdFindResult.emailInvalid) {
            return "redirect:/forgot-id?error=emailFormat";
        }
        if (result.result() == UserProfileService.UserIdFindResult.emailNotFound) {
            return "redirect:/forgot-id?error=notFound";
        }
        try {
            passwordResetMailService.sendUserId(
                    result.email(),
                    result.name(),
                    result.userId()
            );
            return "redirect:/loginPage?findId=mailSent";
        } catch (IllegalStateException e) {
            if ("mailConfig".equals(e.getMessage())) {
                return "redirect:/forgot-id?error=mailConfig";
            }
            if ("mailProvider".equals(e.getMessage())) {
                return "redirect:/forgot-id?error=mailProvider";
            }
            log.warn("아이디 찾기 메일 발송 실패: {}", e.toString());
            return "redirect:/forgot-id?error=mail";
        } catch (Exception e) {
            log.warn("아이디 찾기 메일 발송 실패: {}", e.toString());
            return "redirect:/forgot-id?error=mail";
        }
    }

    @PostMapping("/forgot-password")
    public String forgotPasswordSubmit(@RequestParam("email") String email) {
        UserProfileService.PasswordResetIssuePasswordResult result =
                userProfileService.issueTemporaryPasswordByEmail(email);
        if (result.result() == UserProfileService.PasswordResetResult.emailInvalid) {
            return "redirect:/forgot-password?error=emailFormat";
        }
        if (result.result() == UserProfileService.PasswordResetResult.emailNotFound) {
            return "redirect:/forgot-password?error=notFound";
        }
        try {
            passwordResetMailService.sendTemporaryPassword(
                    result.email(),
                    result.name(),
                    result.temporaryPassword(),
                    result.memberUserIdsCsv(),
                    result.partnerLoginIdsCsv()
            );
            return "redirect:/loginPage?reset=mailSent";
        } catch (IllegalStateException e) {
            if ("mailConfig".equals(e.getMessage())) {
                return "redirect:/forgot-password?error=mailConfig";
            }
            if ("mailProvider".equals(e.getMessage())) {
                return "redirect:/forgot-password?error=mailProvider";
            }
            log.warn("비밀번호 찾기 메일 발송 실패: {}", e.toString());
            return "redirect:/forgot-password?error=mail";
        } catch (Exception e) {
            log.warn("비밀번호 찾기 메일 발송 실패: {}", e.toString());
            return "redirect:/forgot-password?error=mail";
        }
    }

    @GetMapping("/logoutNow")
    public String logoutNow(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication
    ) {
        WebAuthUtils.performLogout(request, response, authentication);
        return "redirect:/";
    }
}
