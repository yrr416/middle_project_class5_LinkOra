/**
 * 사업자(partner) 회원가입 시 중복·스키마 오류 등 결과를 구분하는 등록 유스케이스 계약.
 */
package org.study.project05.signup.service;

public interface PartnerSignupService {
    enum PartnerSignupResult {
        SUCCESS,
        duplicateId,
        duplicateEmail,
        duplicateBizNo,
        tableOrColumnMissing,
        FAILED
    }

    PartnerSignupResult register(
            String userId,
            String password,
            String name,
            String email,
            String address,
            String phone,
            String businessNo,
            String profileImagePath
    );

    /** 사업자 테이블에 동일 p_id가 있는지 (일반 회원 여부는 별도 검사). */
    boolean existsPartnerId(String partnerId);

    /** partner 테이블에 동일 이메일이 있는지 (일반 회원 이메일은 별도 검사). */
    boolean existsPartnerEmail(String email);
}
