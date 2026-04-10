/**
 * 일반 회원 프로필: 가입, OAuth 연동(upsert), 비밀번호 변경·임시발급, 아이디 찾기, 프로필·탈퇴.
 */
package org.study.project05.member.service;

import org.study.project05.member.vo.UserProfileVO;

public interface UserProfileService {
    enum PasswordChangeResult {
        SUCCESS,
        userNotFound,
        currentPasswordMismatch
    }

    enum PasswordResetResult {
        SUCCESS,
        emailNotFound,
        emailInvalid
    }

    enum UserIdFindResult {
        SUCCESS,
        emailNotFound,
        emailInvalid
    }

    UserProfileVO getByUserId(String userId);

    boolean existsUserId(String userId);

    boolean existsEmail(String email);

    boolean register(String userId, String password, String name, String email, String address, String phone, String profilePath);

    String upsertOAuthUser(String providerPrefix, String oauthSubject, String name, String email, String address, String phone, String profileImageUrl);

    PasswordChangeResult changePassword(String userId, String currentPassword, String newPassword);

    boolean updateProfileImage(String userId, String profilePath);

    boolean deleteByUserId(String userId);

    PasswordResetIssuePasswordResult issueTemporaryPasswordByEmail(String email);

    UserIdFindIssueResult issueUserIdByEmail(String email);

    record PasswordResetIssuePasswordResult(PasswordResetResult result, String email, String name, String temporaryPassword) {
        public static PasswordResetIssuePasswordResult success(String email, String name, String temporaryPassword) {
            return new PasswordResetIssuePasswordResult(PasswordResetResult.SUCCESS, email, name, temporaryPassword);
        }

        public static PasswordResetIssuePasswordResult notFound() {
            return new PasswordResetIssuePasswordResult(PasswordResetResult.emailNotFound, null, null, null);
        }

        public static PasswordResetIssuePasswordResult invalid() {
            return new PasswordResetIssuePasswordResult(PasswordResetResult.emailInvalid, null, null, null);
        }
    }

    record UserIdFindIssueResult(UserIdFindResult result, String email, String name, String userId) {
        public static UserIdFindIssueResult success(String email, String name, String userId) {
            return new UserIdFindIssueResult(UserIdFindResult.SUCCESS, email, name, userId);
        }

        public static UserIdFindIssueResult notFound() {
            return new UserIdFindIssueResult(UserIdFindResult.emailNotFound, null, null, null);
        }

        public static UserIdFindIssueResult invalid() {
            return new UserIdFindIssueResult(UserIdFindResult.emailInvalid, null, null, null);
        }
    }
}
