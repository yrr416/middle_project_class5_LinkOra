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
}
