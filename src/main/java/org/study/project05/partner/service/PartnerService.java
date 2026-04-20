/**
 * 사업자(partner) 조회, 프로필 이미지 갱신, 비밀번호 변경, 계정 삭제 계약.
 */
package org.study.project05.partner.service;

import org.study.project05.partner.vo.PartnerVO;

public interface PartnerService {
    enum PasswordChangeResult {
        SUCCESS,
        partnerNotFound,
        currentPasswordMismatch
    }

    PartnerVO getByPartnerId(String partnerId);

    boolean existsPartnerId(String partnerId);

    boolean existsEmail(String email);

    boolean existsBusinessNo(String businessNo);

    boolean updateProfileImage(String partnerId, String profileImagePath);

    boolean deleteByPartnerId(String partnerId);

    PasswordChangeResult changePassword(String partnerId, String currentPassword, String newPassword);

    boolean updateInfo(String partnerId, String name, String email, String phone, String address);
}
