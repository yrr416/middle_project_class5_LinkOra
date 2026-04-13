/**
 * 사업자 회원가입: partner 테이블 중복 검사 후 비밀번호 암호화·INSERT 수행.
 */
package org.study.project05.signup.service.impl;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.study.project05.partner.mapper.PartnerMapper;
import org.study.project05.signup.service.PartnerSignupService;

@Service
public class PartnerSignupServiceImpl implements PartnerSignupService {
    private final PartnerMapper partnerMapper;
    private final PasswordEncoder passwordEncoder;

    public PartnerSignupServiceImpl(PartnerMapper partnerMapper, PasswordEncoder passwordEncoder) {
        this.partnerMapper = partnerMapper;
        this.passwordEncoder = passwordEncoder;
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
        try {
            if (partnerMapper.countByPartnerId(userId) > 0) {
                return PartnerSignupResult.duplicateId;
            }
            if (email != null && !email.isBlank() && partnerMapper.countByEmail(email) > 0) {
                return PartnerSignupResult.duplicateEmail;
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
                    email,
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
