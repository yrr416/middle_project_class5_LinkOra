/**
 * 비밀번호 재설정·아이디 찾기 시 회원 메일로 안내 발송 계약.
 */
package org.study.project05.member.service;

public interface PasswordResetMailService {
    void sendTemporaryPassword(
            String toEmail,
            String name,
            String temporaryPassword,
            String memberUserIdsCsv,
            String partnerLoginIdsCsv
    );

    void sendUserId(String toEmail, String name, String userId);
}
