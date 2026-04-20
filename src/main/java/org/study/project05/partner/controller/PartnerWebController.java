/**
 * 사업자 마이페이지: 정보 표시, 비밀번호 변경, 프로필 이미지, 탈퇴(비밀번호 확인 후 삭제·로그아웃).
 */
package org.study.project05.partner.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
import org.study.project05.common.util.ProfileImageUrls;
import org.study.project05.common.util.WebAuthUtils;
import org.study.project05.partner.service.PartnerService;
import org.study.project05.partner.vo.PartnerVO;

import java.util.Objects;

@Controller
public class PartnerWebController {

    private final PartnerService partnerService;
    private final ProfileImageStorageService profileImageStorage;
    private final PasswordEncoder passwordEncoder;

    public PartnerWebController(
            PartnerService partnerService,
            ProfileImageStorageService profileImageStorage,
            PasswordEncoder passwordEncoder
    ) {
        this.partnerService = partnerService;
        this.profileImageStorage = profileImageStorage;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/partner/mypage")
    public String partnerMyPage(
            Authentication authentication,
            HttpServletRequest request,
            HttpServletResponse response,
            Model model,
            @RequestParam(value = "withdrawError", required = false) String withdrawError,
            @RequestParam(value = "pwdError", required = false) String pwdError,
            @RequestParam(value = "pwdChanged", required = false) String pwdChanged,
            @RequestParam(value = "infoUpdated", required = false) String infoUpdated,
            @RequestParam(value = "profileUpdated", required = false) String profileUpdated,
            @RequestParam(value = "profileError", required = false) String profileError
    ) {
        if (WebAuthUtils.isAnonymous(authentication)) {
            return "redirect:/loginPage";
        }
        if (!WebAuthUtils.hasRole(authentication, "ROLE_PARTNER")) {
            return "redirect:/mypage";
        }
        String partnerId = authentication.getName();
        PartnerVO partner = partnerService.getByPartnerId(partnerId);
        if (partner != null && Integer.valueOf(0).equals(partner.getActive())) {
            WebAuthUtils.performLogout(request, response, authentication);
            return "redirect:/loginPage?error=inactive";
        }
        model.addAttribute("partnerId", partnerId);
        model.addAttribute("name", partner != null ? partner.getName() : "");
        model.addAttribute("email", partner != null ? partner.getEmail() : "");
        model.addAttribute("phone", partner != null ? partner.getPhone() : "");
        model.addAttribute("address", partner != null ? partner.getAddress() : "");
        model.addAttribute("profileImage", ProfileImageUrls.forRequest(request, partner != null ? partner.getProfileImage() : ""));
        model.addAttribute("bizNo", formatBizNo(partner != null ? partner.getBusinessNo() : ""));
        model.addAttribute("withdrawError", withdrawError);
        model.addAttribute("pwdError", pwdError);
        model.addAttribute("pwdChanged", pwdChanged);
        model.addAttribute("infoUpdated", infoUpdated);
        model.addAttribute("profileUpdated", profileUpdated);
        model.addAttribute("profileError", profileError);
        return "partner/mypage";
    }

    @PostMapping("/partner/mypage/password")
    public String changePartnerPassword(
            Authentication authentication,
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("newPasswordConfirm") String newPasswordConfirm
    ) {
        if (WebAuthUtils.isAnonymous(authentication) || !WebAuthUtils.hasRole(authentication, "ROLE_PARTNER")) {
            return "redirect:/loginPage";
        }
        // null·길이 체크를 일치 여부보다 먼저 수행 (NPE 방지)
        if (newPassword == null || newPassword.length() < 8) {
            return "redirect:/partner/mypage?pwdError=weak";
        }
        if (!Objects.equals(newPassword, newPasswordConfirm)) {
            return "redirect:/partner/mypage?pwdError=mismatch";
        }
        if (!PasswordPolicy.meetsComplexity(newPassword)) {
            return "redirect:/partner/mypage?pwdError=complex";
        }
        PartnerService.PasswordChangeResult result =
                partnerService.changePassword(authentication.getName(), currentPassword, newPassword);
        if (result == PartnerService.PasswordChangeResult.currentPasswordMismatch) {
            return "redirect:/partner/mypage?pwdError=current";
        }
        if (result != PartnerService.PasswordChangeResult.SUCCESS) {
            return "redirect:/partner/mypage?pwdError=failed";
        }
        return "redirect:/partner/mypage?pwdChanged=success";
    }

    @PostMapping("/partner/mypage/info")
    public String updatePartnerInfo(
            Authentication authentication,
            @RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            @RequestParam("address") String address,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage
    ) {
        if (WebAuthUtils.isAnonymous(authentication) || !WebAuthUtils.hasRole(authentication, "ROLE_PARTNER")) {
            return "redirect:/loginPage";
        }
        // 이미지가 첨부된 경우: 서버에 저장 후 DB에 경로 업데이트
        if (profileImage != null && !profileImage.isEmpty()) {
            try {
                String path = profileImageStorage.storeIfValid(profileImage);
                if (path != null) {
                    partnerService.updateProfileImage(authentication.getName(), path);
                }
            } catch (Exception ignored) {
                // 이미지 저장 실패해도 나머지 정보는 저장
            }
        }
        partnerService.updateInfo(authentication.getName(), name, email, phone, address);
        return "redirect:/partner/mypage?infoUpdated=success";
    }

    @PostMapping("/partner/mypage/profile")
    public String changePartnerProfileImage(
            Authentication authentication,
            @RequestParam("profileImage") MultipartFile profileImage
    ) {
        if (WebAuthUtils.isAnonymous(authentication) || !WebAuthUtils.hasRole(authentication, "ROLE_PARTNER")) {
            return "redirect:/loginPage";
        }
        if (profileImage == null || profileImage.isEmpty()) {
            return "redirect:/partner/mypage?profileError=empty";
        }
        try {
            // 브라우저에서 접근 가능한 URL 반환 (ContextPath 자동 포함을 위해 /static/upload/...으로 반환)
            String path = profileImageStorage.storeIfValid(profileImage);
            if (path == null) {
                // 허용되지 않는 확장자이거나 content-type 거부
                return "redirect:/partner/mypage?profileError=invalid";
            }
            // 반환된 웹 경로를 DB p_profile 컬럼에 저장
            boolean saved = partnerService.updateProfileImage(authentication.getName(), path);
            if (!saved) {
                return "redirect:/partner/mypage?profileError=dbFail";
            }
        } catch (Exception e) {
            return "redirect:/partner/mypage?profileError=serverError";
        }
        return "redirect:/partner/mypage?profileUpdated=success";
    }

    @PostMapping("/partner/mypage/delete")
    public String deletePartnerAccount(
            Authentication authentication,
            @RequestParam("currentPassword") String currentPassword,
            HttpServletRequest request,
            HttpServletResponse response
    ) {
        if (WebAuthUtils.isAnonymous(authentication) || !WebAuthUtils.hasRole(authentication, "ROLE_PARTNER")) {
            return "redirect:/loginPage";
        }
        PartnerVO partner = partnerService.getByPartnerId(authentication.getName());
        if (partner == null || partner.getPassword() == null || partner.getPassword().isBlank()) {
            return "redirect:/partner/mypage?withdrawError=failed";
        }
        if (!passwordEncoder.matches(currentPassword, partner.getPassword())) {
            return "redirect:/partner/mypage?withdrawError=password";
        }
        boolean deleted = partnerService.deleteByPartnerId(authentication.getName());
        if (!deleted) {
            return "redirect:/partner/mypage?withdrawError=failed";
        }
        WebAuthUtils.performLogout(request, response, authentication);
        return "redirect:/loginPage?withdraw=success";
    }

    @GetMapping("/partner/mypage/delete")
    public String denyPartnerGetDelete() {
        // 탈퇴는 POST 제출(모달 비밀번호 확인)로만 허용
        return "redirect:/partner/mypage?withdrawError=method";
    }

    private static String formatBizNo(String value) {
        if (value == null) {
            return "";
        }
        String trimmed = value.trim();
        if (trimmed.isBlank()) {
            return "";
        }
        String digits = trimmed.replaceAll("\\D", "");
        if (digits.length() == 10) {
            return digits.substring(0, 3) + "-" + digits.substring(3, 5) + "-" + digits.substring(5);
        }
        return trimmed;
    }

}
