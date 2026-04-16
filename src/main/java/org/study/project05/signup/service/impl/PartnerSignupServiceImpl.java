/**
 * 사업자 회원가입: partner 테이블 중복 검사 후 비밀번호 암호화·INSERT 수행.
 */
package org.study.project05.signup.service.impl;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.partner.mapper.PartnerMapper;
import org.study.project05.signup.service.PartnerSignupService;

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
        if (partnerId == null || partnerId.isBlank()) {
            return false;
        }
        try {
            return partnerMapper.countByPartnerId(partnerId.trim()) > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean existsPartnerEmail(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }
        try {
            return partnerMapper.countByEmail(email.trim()) > 0;
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
        String id = userId != null ? userId.trim() : "";
        if (id.isEmpty()) {
            return PartnerSignupResult.FAILED;
        }
        userId = id;
        String mail = email != null ? email.trim() : "";
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
            if (businessNo != null && !businessNo.isBlank() && partnerMapper.countByBusinessNo(businessNo) > 0) {
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
                    businessNo,
                    profileImagePath
            );
            return updated > 0 ? PartnerSignupResult.SUCCESS : PartnerSignupResult.FAILED;
        } catch (Exception e) {
            return PartnerSignupResult.tableOrColumnMissing;
        }
    }

}
