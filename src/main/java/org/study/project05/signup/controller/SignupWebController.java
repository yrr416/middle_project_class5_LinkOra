/**
 * 회원가입 웹: 일반 회원(/signup)·사업자(/partner-signup) 가입 폼 표시 및 검증 후 등록 처리.
 */
package org.study.project05.signup.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.study.project05.common.service.ProfileImageStorageService;
import org.study.project05.common.util.PasswordPolicy;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.signup.service.PartnerSignupService;

import java.io.IOException;
import java.util.Locale;
import java.util.Objects;

@Controller
public class SignupWebController {

    private final UserProfileService userProfileService;
    private final PartnerSignupService partnerSignupService;
    private final ProfileImageStorageService profileImageStorage;

    public SignupWebController(
            UserProfileService userProfileService,
            PartnerSignupService partnerSignupService,
            ProfileImageStorageService profileImageStorage
    ) {
        this.userProfileService = userProfileService;
        this.partnerSignupService = partnerSignupService;
        this.profileImageStorage = profileImageStorage;
    }

    @GetMapping("/signup")
    public String signupPage() {
        return "member/signup";
    }

    @GetMapping("/partner-signup")
    public String partnerSignupPage() {
        return "partner/signup";
    }

    @PostMapping("/signup")
    public String signupSubmit(
            @RequestParam("userId") String userId,
            @RequestParam("userPwd") String password,
            @RequestParam(value = "userPwdConfirm", defaultValue = "") String passwordConfirm,
            @RequestParam("userName") String name,
            @RequestParam("userPhone") String phone,
            @RequestParam("userEmail") String email,
            @RequestParam("userAddr") String address,
            @RequestParam(value = "agreePrivacy", required = false) String agreePrivacy,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage
    ) {
        if (!"true".equals(agreePrivacy)) {
            return "redirect:/signup?error=privacyRequired";
        }
        if (!Objects.equals(password, passwordConfirm)) {
            return "redirect:/signup?error=passwordMismatch";
        }
        if (password == null || password.length() < 8) {
            return "redirect:/signup?error=passwordWeak";
        }
        if (!PasswordPolicy.meetsComplexity(password)) {
            return "redirect:/signup?error=passwordComplex";
        }
        if (phone == null || !phone.matches("\\d{3}-\\d{4}-\\d{4}")) {
            return "redirect:/signup?error=phoneFormat";
        }
        String trimmedEmail = normalizeEmail(email);
        if (trimmedEmail.isEmpty() || !trimmedEmail.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return "redirect:/signup?error=emailFormat";
        }
        String trimmedUserId = normalizeUserId(userId);
        if (trimmedUserId.isEmpty()) {
            return "redirect:/signup?error=failed";
        }
        if (userProfileService.existsUserId(trimmedUserId) || partnerSignupService.existsPartnerId(trimmedUserId)) {
            return "redirect:/signup?error=duplicateId";
        }
        if (userProfileService.existsEmail(trimmedEmail) || partnerSignupService.existsPartnerEmail(trimmedEmail)) {
            return "redirect:/signup?error=duplicateEmail";
        }

        String profilePath = null;
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                profilePath = profileImageStorage.storeIfValid(profileImage);
                if (profilePath == null) {
                    return "redirect:/signup?error=invalidImage";
                }
            }
        } catch (IOException e) {
            return "redirect:/signup?error=failed";
        }

        boolean saved = userProfileService.register(trimmedUserId, password, name, trimmedEmail, address, phone, profilePath);
        if (!saved) {
            return "redirect:/signup?error=failed";
        }
        return "redirect:/loginPage?signup=success";
    }

    @PostMapping("/partner-signup")
    public String partnerSignupSubmit(
            @RequestParam("partnerId") String userId,
            @RequestParam("partnerPwd") String password,
            @RequestParam(value = "partnerPwdConfirm", defaultValue = "") String passwordConfirm,
            @RequestParam("partnerName") String name,
            @RequestParam("partnerBizNo") String businessNo,
            @RequestParam("partnerPhone") String phone,
            @RequestParam("partnerEmail") String email,
            @RequestParam("partnerAddr") String address,
            @RequestParam(value = "agreePrivacy", required = false) String agreePrivacy,
            @RequestParam(value = "partnerProfileImage", required = false) MultipartFile profileImage
    ) {
        if (!"true".equals(agreePrivacy)) {
            return "redirect:/partner-signup?error=privacyRequired";
        }
        if (!Objects.equals(password, passwordConfirm)) {
            return "redirect:/partner-signup?error=passwordMismatch";
        }
        if (password == null || password.length() < 8) {
            return "redirect:/partner-signup?error=passwordWeak";
        }
        if (!PasswordPolicy.meetsComplexity(password)) {
            return "redirect:/partner-signup?error=passwordComplex";
        }
        if (phone == null || !phone.matches("\\d{3}-\\d{4}-\\d{4}")) {
            return "redirect:/partner-signup?error=phoneFormat";
        }
        String trimmedPartnerEmail = normalizeEmail(email);
        String trimmedPartnerId = normalizeUserId(userId);
        if (trimmedPartnerId.isEmpty()) {
            return "redirect:/partner-signup?error=failed";
        }
        if (userProfileService.existsUserId(trimmedPartnerId) || partnerSignupService.existsPartnerId(trimmedPartnerId)) {
            return "redirect:/partner-signup?error=duplicateId";
        }
        if (userProfileService.existsEmail(trimmedPartnerEmail) || partnerSignupService.existsPartnerEmail(trimmedPartnerEmail)) {
            return "redirect:/partner-signup?error=duplicateEmail";
        }
        if (trimmedPartnerEmail.isEmpty() || !trimmedPartnerEmail.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return "redirect:/partner-signup?error=emailFormat";
        }
        if (businessNo == null || !businessNo.matches("\\d{3}-\\d{2}-\\d{5}")) {
            return "redirect:/partner-signup?error=bizNoFormat";
        }
        String profilePath = null;
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                profilePath = profileImageStorage.storeIfValid(profileImage);
                if (profilePath == null) {
                    return "redirect:/partner-signup?error=invalidImage";
                }
            }
        } catch (IOException e) {
            return "redirect:/partner-signup?error=failed";
        }

        PartnerSignupService.PartnerSignupResult result =
                partnerSignupService.register(trimmedPartnerId, password, name, trimmedPartnerEmail, address, phone, businessNo, profilePath);

        if (result == PartnerSignupService.PartnerSignupResult.duplicateId) {
            return "redirect:/partner-signup?error=duplicateId";
        }
        if (result == PartnerSignupService.PartnerSignupResult.duplicateEmail) {
            return "redirect:/partner-signup?error=duplicateEmail";
        }
        if (result == PartnerSignupService.PartnerSignupResult.duplicateBizNo) {
            return "redirect:/partner-signup?error=duplicateBizNo";
        }
        if (result == PartnerSignupService.PartnerSignupResult.tableOrColumnMissing) {
            return "redirect:/partner-signup?error=schema";
        }
        if (result != PartnerSignupService.PartnerSignupResult.SUCCESS) {
            return "redirect:/partner-signup?error=failed";
        }
        return "redirect:/loginPage?signup=partnerSuccess";
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
