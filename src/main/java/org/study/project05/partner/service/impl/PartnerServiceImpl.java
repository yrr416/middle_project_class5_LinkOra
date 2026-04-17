/**
 * PartnerService 구현: partner 테이블(MyBatis) 기반 조회·수정·삭제·비밀번호 변경.
 */
package org.study.project05.partner.service.impl;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.study.project05.partner.mapper.PartnerMapper;
import org.study.project05.partner.service.PartnerService;
import org.study.project05.partner.vo.PartnerVO;

@Service
public class PartnerServiceImpl implements PartnerService {
    private final PartnerMapper partnerMapper;
    private final PasswordEncoder passwordEncoder;

    public PartnerServiceImpl(PartnerMapper partnerMapper, PasswordEncoder passwordEncoder) {
        this.partnerMapper = partnerMapper;
        this.passwordEncoder = passwordEncoder;
    }

    public PartnerVO getByPartnerId(String partnerId) {
        try {
            return partnerMapper.findByPartnerId(partnerId);
        } catch (Exception e) {
            return null;
        }
    }

    public boolean existsPartnerId(String partnerId) {
        try {
            return partnerMapper.countByPartnerId(partnerId) > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean existsEmail(String email) {
        if (email == null || email.isBlank()) {
            return false;
        }
        try {
            return partnerMapper.countByEmail(email) > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean existsBusinessNo(String businessNo) {
        if (businessNo == null || businessNo.isBlank()) {
            return false;
        }
        try {
            return partnerMapper.countByBusinessNo(businessNo) > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean updateProfileImage(String partnerId, String profileImagePath) {
        if (partnerId == null || partnerId.isBlank() || profileImagePath == null || profileImagePath.isBlank()) {
            return false;
        }
        try {
            return partnerMapper.updateProfileImageByPartnerId(partnerId, profileImagePath) > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean deleteByPartnerId(String partnerId) {
        if (partnerId == null || partnerId.isBlank()) {
            return false;
        }
        try {
            // 물리 삭제 대신 p_active를 0으로 설정하는 논리 삭제
            return partnerMapper.deactivateByPartnerId(partnerId) > 0;
        } catch (Exception e) {
            return false;
        }
    }

    public PasswordChangeResult changePassword(String partnerId, String currentPassword, String newPassword) {
        if (partnerId == null || partnerId.isBlank()) {
            return PasswordChangeResult.partnerNotFound;
        }
        try {
            PartnerVO partner = partnerMapper.findByPartnerId(partnerId);
            if (partner == null || partner.getPassword() == null || partner.getPassword().isBlank()) {
                return PasswordChangeResult.partnerNotFound;
            }
            if (!passwordEncoder.matches(currentPassword, partner.getPassword())) {
                return PasswordChangeResult.currentPasswordMismatch;
            }
            String encoded = passwordEncoder.encode(newPassword);
            int updated = partnerMapper.updatePasswordByPartnerId(partnerId, encoded);
            return updated > 0 ? PasswordChangeResult.SUCCESS : PasswordChangeResult.partnerNotFound;
        } catch (Exception e) {
            return PasswordChangeResult.partnerNotFound;
        }
    }
}
