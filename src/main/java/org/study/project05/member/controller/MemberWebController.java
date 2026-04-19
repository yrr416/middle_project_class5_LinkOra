/**
 * 일반 회원 마이페이지: 조회, 비밀번호 변경, 프로필 이미지, 탈퇴(비밀번호 확인 후 삭제·로그아웃).
 */
package org.study.project05.member.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.study.project05.common.service.ProfileImageStorageService;
import org.study.project05.common.util.PasswordPolicy;
import org.study.project05.common.util.WebAuthUtils;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.member.vo.UserProfileVO;

import java.util.Objects;

@Controller
public class MemberWebController {

    private final UserProfileService userProfileService;
    private final ProfileImageStorageService profileImageStorage;
    private final PasswordEncoder passwordEncoder;

    public MemberWebController(
            UserProfileService userProfileService,
            ProfileImageStorageService profileImageStorage,
            PasswordEncoder passwordEncoder
    ) {
        this.userProfileService = userProfileService;
        this.profileImageStorage = profileImageStorage;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/mypage")
    public String myPage(
            Authentication authentication,
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            Model model,
            @RequestParam(value = "pwdError", required = false) String pwdError,
            @RequestParam(value = "pwdChanged", required = false) String pwdChanged,
            @RequestParam(value = "withdrawError", required = false) String withdrawError
    ) {
        if (!WebAuthUtils.isAnonymous(authentication) && WebAuthUtils.hasRole(authentication, "ROLE_PARTNER")) {
            return "redirect:/partner/mypage";
        }
        if (!WebAuthUtils.isAnonymous(authentication)) {
            UserProfileVO profile = userProfileService.getByUserId(authentication.getName());
            if (profile != null) {
                if (Integer.valueOf(0).equals(profile.getActive())) {
                    WebAuthUtils.performLogout(request, response, authentication);
                    return "redirect:/loginPage?error=inactive";
                }
                String profileUserId = profile.getUserId();
                boolean oauthLinked = profileUserId != null
                        && (profileUserId.startsWith("kakao_") || profileUserId.startsWith("naver_"));
                String exposedUsername = profile.getUserId();
                if (oauthLinked && profileUserId != null) {
                    int cut = profileUserId.indexOf('_');
                    if (cut >= 0 && cut + 1 < profileUserId.length()) {
                        exposedUsername = profileUserId.substring(cut + 1);
                    }
                }
                String oauthProvider = "";
                if (oauthLinked && profileUserId != null) {
                    oauthProvider = profileUserId.startsWith("kakao_") ? "카카오" : "네이버";
                }
                model.addAttribute("oauthLogin", oauthLinked);
                model.addAttribute("oauthProvider", oauthProvider);
                model.addAttribute("name", profile.getName());
                model.addAttribute("phone", profile.getPhone());
                model.addAttribute("address", profile.getAddress());
                model.addAttribute("username", exposedUsername);
                model.addAttribute("email", profile.getEmail());
                model.addAttribute("joinDate", profile.getCreatedDate());
                model.addAttribute("profileImage", profile.getProfileImage());
                model.addAttribute("pwdError", pwdError);
                model.addAttribute("pwdChanged", pwdChanged);
                model.addAttribute("withdrawError", withdrawError);
                return "member/mypage";
            }
        }

        String kakaoId = (String) session.getAttribute("kakaoId");
        if (kakaoId != null && !kakaoId.isBlank()) {
            applyKakaoSessionToModel(model, session);
            model.addAttribute("withdrawError", withdrawError);
            return "member/mypage";
        }

        String naverId = (String) session.getAttribute("naverId");
        if (naverId != null && !naverId.isBlank()) {
            applyNaverSessionToModel(model, session);
            model.addAttribute("withdrawError", withdrawError);
            return "member/mypage";
        }

        return "redirect:/loginPage";
    }

    @PostMapping("/mypage/password")
    public String changePassword(
            Authentication authentication,
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("newPasswordConfirm") String newPasswordConfirm
    ) {
        if (authentication == null) {
            return "redirect:/loginPage";
        }
        if (!Objects.equals(newPassword, newPasswordConfirm)) {
            return "redirect:/mypage?pwdError=mismatch";
        }
        if (newPassword == null || newPassword.length() < 8) {
            return "redirect:/mypage?pwdError=weak";
        }
        if (!PasswordPolicy.meetsComplexity(newPassword)) {
            return "redirect:/mypage?pwdError=complex";
        }
        UserProfileService.PasswordChangeResult result =
                userProfileService.changePassword(authentication.getName(), currentPassword, newPassword);
        if (result == UserProfileService.PasswordChangeResult.currentPasswordMismatch) {
            return "redirect:/mypage?pwdError=current";
        }
        if (result != UserProfileService.PasswordChangeResult.SUCCESS) {
            return "redirect:/mypage?pwdError=failed";
        }
        return "redirect:/mypage?pwdChanged=success";
    }

    @PostMapping("/mypage/profile")
    public String changeProfileImage(
            Authentication authentication,
            @RequestParam("profileImage") MultipartFile profileImage
    ) {
        if (authentication == null) {
            return "redirect:/loginPage";
        }
        if (profileImage == null || profileImage.isEmpty()) {
            return "redirect:/mypage";
        }
        try {
            String path = profileImageStorage.storeIfValid(profileImage);
            if (path == null) {
                return "redirect:/mypage";
            }
            userProfileService.updateProfileImage(authentication.getName(), path);
        } catch (Exception ignored) {
        }
        return "redirect:/mypage";
    }

    @PostMapping("/mypage/delete")
    public String deleteUserAccount(
            Authentication authentication,
            @RequestParam("currentPassword") String currentPassword,
            HttpServletRequest request,
            HttpServletResponse response
    ) {
        if (WebAuthUtils.isAnonymous(authentication) || WebAuthUtils.hasRole(authentication, "ROLE_PARTNER")) {
            return "redirect:/loginPage";
        }
        UserProfileVO user = userProfileService.getByUserId(authentication.getName());
        if (user == null || user.getPassword() == null || user.getPassword().isBlank()) {
            return "redirect:/mypage?withdrawError=failed";
        }
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            return "redirect:/mypage?withdrawError=password";
        }
        boolean deleted = userProfileService.deleteByUserId(authentication.getName());
        if (!deleted) {
            return "redirect:/mypage?withdrawError=failed";
        }
        WebAuthUtils.performLogout(request, response, authentication);
        return "redirect:/loginPage?withdraw=success";
    }

    @GetMapping("/mypage/delete")
    public String denyGetDelete() {
        // 탈퇴는 POST 제출(모달 비밀번호 확인)로만 허용
        return "redirect:/mypage?withdrawError=method";
    }

    private static void applyKakaoSessionToModel(Model model, HttpSession session) {
        String kakaoId = (String) session.getAttribute("kakaoId");
        String nickname = (String) session.getAttribute("kakaoNickname");
        String email = (String) session.getAttribute("kakaoEmail");
        String image = (String) session.getAttribute("kakaoProfileImage");
        model.addAttribute("oauthLogin", true);
        model.addAttribute("oauthProvider", "카카오");
        model.addAttribute("name", nickname != null && !nickname.isBlank() ? nickname : "카카오 사용자");
        model.addAttribute("username", kakaoId != null && !kakaoId.isBlank() ? kakaoId : "—");
        model.addAttribute("joinDate", "—");
        model.addAttribute("email", email != null && !email.isBlank() ? email : null);
        model.addAttribute("phone", "—");
        model.addAttribute("address", "—");
        model.addAttribute("profileImage", image != null && !image.isBlank() ? image : null);
        model.addAttribute("pwdError", null);
        model.addAttribute("pwdChanged", null);
    }

    private static void applyNaverSessionToModel(Model model, HttpSession session) {
        String naverId = (String) session.getAttribute("naverId");
        String name = (String) session.getAttribute("naverName");
        String phone = (String) session.getAttribute("naverPhone");
        String email = (String) session.getAttribute("naverEmail");
        model.addAttribute("oauthLogin", true);
        model.addAttribute("oauthProvider", "네이버");
        model.addAttribute("name", name != null && !name.isBlank() ? name : "네이버 사용자");
        model.addAttribute("username", naverId != null && !naverId.isBlank() ? naverId : "—");
        model.addAttribute("joinDate", "—");
        model.addAttribute("email", email != null && !email.isBlank() ? email : null);
        model.addAttribute("phone", phone != null && !phone.isBlank() ? phone : "—");
        model.addAttribute("address", "—");
        model.addAttribute("profileImage", null);
        model.addAttribute("pwdError", null);
        model.addAttribute("pwdChanged", null);
    }
}
