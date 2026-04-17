/**
 * 사업자 회원가입: partner 테이블 중복 검사 후 비밀번호 암호화·INSERT 수행.
 */
package org.study.project05.signup.service.impl;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.partner.mapper.PartnerMapper;
import org.study.project05.signup.service.PartnerSignupService;

import java.util.Locale;

@Service
public class PartnerSignupServiceImpl implements PartnerSignupService {
    private final PartnerMapper partnerMapper;
    private final PasswordEncoder passwordEncoder;
    private final UserProfileService userProfileService;

    public PartnerSignupServiceImpl(
            PartnerMapper partnerMapper,
            PasswordEncoder passwordEncoder,
            UserProfileService userProfileService
    ) {
        this.partnerMapper = partnerMapper;
        this.passwordEncoder = passwordEncoder;
        this.userProfileService = userProfileService;
    }

    public boolean existsPartnerId(String partnerId) {
        String normalized = normalizeUserId(partnerId);
        if (normalized.isEmpty()) return false;
        try {
            return partnerMapper.countByPartnerId(normalized) > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean existsPartnerEmail(String email) {
        String normalized = normalizeEmail(email);
        if (normalized.isEmpty()) return false;
        try {
            return partnerMapper.countByEmail(normalized) > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public PartnerSignupResult register(
            String userId,
            String password,
            String name,
            String email,
            String address,
            String phone,
            String businessNo,
            String profileImagePath
    ) {
        String id = normalizeUserId(userId);
        if (id.isEmpty()) {
            return PartnerSignupResult.FAILED;
        }
        userId = id;
        String mail = normalizeEmail(email);
        String normalizedBusinessNo = normalizeBusinessNo(businessNo);
        try {
            if (userProfileService.existsUserId(userId)) {
                return PartnerSignupResult.duplicateId;
            }
            if (partnerMapper.countByPartnerId(userId) > 0) {
                return PartnerSignupResult.duplicateId;
            }
            if (!mail.isBlank()) {
                if (userProfileService.existsEmail(mail)) {
                    return PartnerSignupResult.duplicateEmail;
                }
                if (partnerMapper.countByEmail(mail) > 0) {
                    return PartnerSignupResult.duplicateEmail;
                }
            }
            if (!normalizedBusinessNo.isBlank() && partnerMapper.countByBusinessNo(normalizedBusinessNo) > 0) {
                return PartnerSignupResult.duplicateBizNo;
            }
        } catch (Exception e) {
            return PartnerSignupResult.tableOrColumnMissing;
        }
        try {
            int updated = partnerMapper.insertPartner(
                    userId,
                    passwordEncoder.encode(password),
                    name,
                    mail,
                    address,
                    phone,
                    normalizedBusinessNo,
                    profileImagePath
            );
            return updated > 0 ? PartnerSignupResult.SUCCESS : PartnerSignupResult.FAILED;
        } catch (Exception e) {
            return PartnerSignupResult.tableOrColumnMissing;
        }
    }

    private static String normalizeUserId(String userId) {
        return userId == null ? "" : userId.trim();
    }

    private static String normalizeEmail(String email) {
        if (email == null) return "";
        String trimmed = email.trim();
        return trimmed.isEmpty() ? "" : trimmed.toLowerCase(Locale.ROOT);
    }

    private static String normalizeBusinessNo(String businessNo) {
        return businessNo == null ? "" : businessNo.trim();
    }
}
