/**
 * PartnerService 구현: partner 테이블(MyBatis) 기반 조회·수정·삭제·비밀번호 변경.
 */
package org.study.project05.partner.service.impl;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.study.project05.login.service.TemporaryPasswordWindowService;
import org.study.project05.partner.mapper.PartnerMapper;
import org.study.project05.partner.service.PartnerService;
import org.study.project05.partner.vo.PartnerVO;

@Slf4j
@Service
public class PartnerServiceImpl implements PartnerService {
    private final PartnerMapper partnerMapper;
    private final PasswordEncoder passwordEncoder;
    private final TemporaryPasswordWindowService temporaryPasswordWindowService;

    public PartnerServiceImpl(
            PartnerMapper partnerMapper,
            PasswordEncoder passwordEncoder,
            TemporaryPasswordWindowService temporaryPasswordWindowService
    ) {
        this.partnerMapper = partnerMapper;
        this.passwordEncoder = passwordEncoder;
        this.temporaryPasswordWindowService = temporaryPasswordWindowService;
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

    public boolean updateInfo(String partnerId, String name, String email, String phone, String address) {
        if (partnerId == null || partnerId.isBlank()) return false;
        try {
            return partnerMapper.updateInfoByPartnerId(partnerId, name, email, phone, address) > 0;
        } catch (Exception e) {
            log.error("[updateInfo] 사업자 정보 수정 실패 - partnerId={}", partnerId, e);
            return false;
        }
    }

    public PasswordChangeResult changePassword(String partnerId, String currentPassword, String newPassword) {
        if (partnerId == null || partnerId.isBlank()) {
            return PasswordChangeResult.partnerNotFound;
        }
        // 1. 파트너 조회
        PartnerVO partner;
        try {
            partner = partnerMapper.findByPartnerId(partnerId);
        } catch (Exception e) {
            log.error("[changePassword] 파트너 조회 실패 - partnerId={}", partnerId, e);
            return PasswordChangeResult.partnerNotFound;
        }

        if (partner == null || partner.getPassword() == null || partner.getPassword().isBlank()) {
            log.warn("[changePassword] 파트너를 찾을 수 없음 - partnerId={}", partnerId);
            return PasswordChangeResult.partnerNotFound;
        }

        // 2. 현재 비밀번호 검증
        try {
            if (!passwordEncoder.matches(currentPassword, partner.getPassword())) {
                return PasswordChangeResult.currentPasswordMismatch;
            }
        } catch (Exception e) {
            // 저장된 비밀번호 형식이 인코더와 맞지 않는 경우 (ex. 알 수 없는 prefix)
            log.error("[changePassword] 비밀번호 검증 중 오류 - partnerId={}, storedPwdPrefix={}",
                    partnerId,
                    partner.getPassword().length() > 7 ? partner.getPassword().substring(0, 7) : "?",
                    e);
            return PasswordChangeResult.currentPasswordMismatch;
        }

        // 3. 새 비밀번호 암호화 후 DB 저장
        try {
            String encoded = passwordEncoder.encode(newPassword);
            int updated = partnerMapper.updatePasswordByPartnerId(partnerId, encoded);
            if (updated <= 0) {
                log.warn("[changePassword] 업데이트 실패 (0 rows) - partnerId={}", partnerId);
                return PasswordChangeResult.partnerNotFound;
            }
            temporaryPasswordWindowService.clearPartnerTemporaryPassword(partnerId);
            return PasswordChangeResult.SUCCESS;
        } catch (Exception e) {
            log.error("[changePassword] DB 업데이트 실패 - partnerId={}", partnerId, e);
            return PasswordChangeResult.partnerNotFound;
        }
    }
}
