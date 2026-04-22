/**
 * UserProfileService 구현: user 테이블(MyBatis) 기반 가입·OAuth·비밀번호·프로필·삭제.
 */
package org.study.project05.member.service.impl;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.study.project05.login.service.TemporaryPasswordWindowService;
import org.study.project05.member.mapper.UserProfileMapper;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.member.vo.UserProfileVO;
import org.study.project05.partner.mapper.PartnerMapper;
import org.study.project05.partner.vo.PartnerVO;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;

import java.util.Locale;
import java.util.UUID;

@Service
public class UserProfileServiceImpl implements UserProfileService {

    private final UserProfileMapper userProfileMapper;
    private final PartnerMapper partnerMapper;
    private final PasswordEncoder passwordEncoder;
    private final TemporaryPasswordWindowService temporaryPasswordWindowService;
    private static final String RESET_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    public UserProfileServiceImpl(
            UserProfileMapper userProfileMapper,
            PartnerMapper partnerMapper,
            PasswordEncoder passwordEncoder,
            TemporaryPasswordWindowService temporaryPasswordWindowService
    ) {
        this.userProfileMapper = userProfileMapper;
        this.partnerMapper = partnerMapper;
        this.passwordEncoder = passwordEncoder;
        this.temporaryPasswordWindowService = temporaryPasswordWindowService;
    }

    public UserProfileVO getByUserId(String userId) {
        return userProfileMapper.findByUserId(userId);
    }

    public boolean existsUserId(String userId) {
        String normalized = normalizeUserId(userId);
        if (normalized.isEmpty()) return false;
        return userProfileMapper.countByUserId(normalized) > 0;
    }

    public boolean existsEmail(String email) {
        String normalized = normalizeEmail(email);
        if (normalized.isEmpty()) return false;
        return userProfileMapper.countByEmail(normalized) > 0;
    }

    public boolean register(
            String userId,
            String password,
            String name,
            String email,
            String address,
            String phone,
            String profilePath
    ) {
        String encoded = passwordEncoder.encode(password);
        return userProfileMapper.insertUser(
                normalizeUserId(userId), encoded, name, normalizeEmail(email), address, phone, profilePath) > 0;
    }

    /**
     * 카카오/네이버 등 OAuth 식별자로 {@code user} 행을 만들거나 갱신합니다.
     *
     * @param providerPrefix DB {@code u_id} 접두사 (예: {@code kakao}, {@code naver})
     * @return 저장된 {@code u_id} (예: {@code kakao_12345})
     */
    public String upsertOAuthUser(
            String providerPrefix,
            String oauthSubject,
            String name,
            String email,
            String address,
            String phone,
            String profileImageUrl
    ) {
        String prefix = providerPrefix != null ? providerPrefix.trim().toLowerCase() : "oauth";
        String subject = oauthSubject != null ? oauthSubject.trim() : "";
        String userId = prefix + "_" + subject;
        String displayName = (name == null || name.isBlank()) ? (prefix + " 사용자") : name.trim();
        String safeEmail = emptyToEmpty(email);
        String safeAddress = emptyToEmpty(address);
        String safePhone = emptyToEmpty(phone);
        String safeProfile = emptyToEmpty(profileImageUrl);

        if (userProfileMapper.countByUserId(userId) > 0) {
            userProfileMapper.updateOauthUserByUserId(
                    userId,
                    displayName,
                    safeEmail,
                    safeAddress,
                    safePhone,
                    safeProfile
            );
            return userId;
        }

        String encodedRandom = passwordEncoder.encode(UUID.randomUUID().toString());
        userProfileMapper.insertUser(
                userId,
                encodedRandom,
                displayName,
                safeEmail,
                safeAddress,
                safePhone,
                safeProfile
        );
        return userId;
    }

    private static String emptyToEmpty(String s) {
        if (s == null || s.isBlank()) {
            return "";
        }
        return s.trim();
    }

    public PasswordChangeResult changePassword(String userId, String currentPassword, String newPassword) {
        UserProfileVO user = userProfileMapper.findByUserId(userId);
        if (user == null || user.getPassword() == null) {
            return PasswordChangeResult.userNotFound;
        }
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            return PasswordChangeResult.currentPasswordMismatch;
        }
        String encoded = passwordEncoder.encode(newPassword);
        int updated = userProfileMapper.updatePasswordByUserId(user.getUserId(), encoded);
        if (updated > 0) {
            temporaryPasswordWindowService.clearMemberTemporaryPassword(user.getUserId());
        }
        return updated > 0 ? PasswordChangeResult.SUCCESS : PasswordChangeResult.userNotFound;
    }

    public boolean updateProfileImage(String userId, String profilePath) {
        if (userId == null || userId.isBlank() || profilePath == null || profilePath.isBlank()) {
            return false;
        }
        return userProfileMapper.updateProfileImageByUserId(userId, profilePath) > 0;
    }

    public boolean deleteByUserId(String userId) {
        if (userId == null || userId.isBlank()) {
            return false;
        }
        // 물리 삭제 대신 u_active를 0으로 설정하는 논리 삭제
        return userProfileMapper.deactivateByUserId(userId) > 0;
    }

    private static String normalizeUserId(String userId) {
        return userId == null ? "" : userId.trim();
    }

    private static String normalizeEmail(String email) {
        if (email == null) return "";
        String trimmed = email.trim();
        return trimmed.isEmpty() ? "" : trimmed.toLowerCase(Locale.ROOT);
    }

    public PasswordResetIssuePasswordResult issueTemporaryPasswordByEmail(String email) {
        if (email == null || email.isBlank() || !email.contains("@")) {
            return PasswordResetIssuePasswordResult.invalid();
        }
        String normalized = normalizeEmail(email);
        if (normalized.isEmpty()) {
            return PasswordResetIssuePasswordResult.invalid();
        }
        List<String> memberIds = userProfileMapper.listUserIdsByEmail(normalized);
        if (memberIds == null) {
            memberIds = new ArrayList<>();
        }
        List<String> partnerIds = partnerMapper.listPartnerIdsByEmail(normalized);
        if (partnerIds == null) {
            partnerIds = new ArrayList<>();
        }
        if (memberIds.isEmpty() && partnerIds.isEmpty()) {
            return PasswordResetIssuePasswordResult.notFound();
        }
        String temporaryPassword = generateTemporaryPassword(10);
        String encoded = passwordEncoder.encode(temporaryPassword);
        // 이메일 조건 UPDATE만 하면, 동일 u_id/p_id에 이메일이 다른 중복 행이 있을 때
        // findByUserId가 고르는 행(LIMIT 1)이 갱신되지 않아 로그인이 계속 실패할 수 있다.
        // 복구 메일에 안내한 로그인 ID마다 u_id/p_id 기준으로 전부 갱신한다.
        LinkedHashSet<String> distinctMemberIds = new LinkedHashSet<>(memberIds);
        for (String uid : distinctMemberIds) {
            if (uid != null && !uid.isBlank()) {
                userProfileMapper.updatePasswordByUserId(uid.strip(), encoded);
            }
        }
        LinkedHashSet<String> distinctPartnerIds = new LinkedHashSet<>(partnerIds);
        for (String pid : distinctPartnerIds) {
            if (pid != null && !pid.isBlank()) {
                partnerMapper.updatePasswordByPartnerId(pid.strip(), encoded);
            }
        }
        temporaryPasswordWindowService.markMemberTemporaryPasswords(distinctMemberIds);
        temporaryPasswordWindowService.markPartnerTemporaryPasswords(distinctPartnerIds);

        String memberCsv = memberIds.isEmpty() ? null : String.join(", ", memberIds);
        String partnerCsv = partnerIds.isEmpty() ? null : String.join(", ", partnerIds);

        UserProfileVO uv = userProfileMapper.findLatestByEmail(normalized);
        PartnerVO pv = partnerMapper.findLatestByEmail(normalized);
        String mailName = "";
        if (uv != null && uv.getName() != null && !uv.getName().isBlank()) {
            mailName = uv.getName();
        } else if (pv != null && pv.getName() != null && !pv.getName().isBlank()) {
            mailName = pv.getName();
        }
        return PasswordResetIssuePasswordResult.success(
                email.trim(),
                mailName,
                temporaryPassword,
                memberCsv,
                partnerCsv
        );
    }

    public UserIdFindIssueResult issueUserIdByEmail(String email) {
        if (email == null || email.isBlank() || !email.contains("@")) {
            return UserIdFindIssueResult.invalid();
        }
        String normalized = normalizeEmail(email);
        if (normalized.isEmpty()) {
            return UserIdFindIssueResult.invalid();
        }
        UserProfileVO user = userProfileMapper.findLatestByEmail(normalized);
        if (user == null || user.getUserId() == null || user.getUserId().isBlank()) {
            return UserIdFindIssueResult.notFound();
        }
        return UserIdFindIssueResult.success(
                user.getEmail() != null ? user.getEmail().trim() : email.trim(),
                user.getName(),
                user.getUserId()
        );
    }

    private static String generateTemporaryPassword(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            int idx = SECURE_RANDOM.nextInt(RESET_CHARS.length());
            sb.append(RESET_CHARS.charAt(idx));
        }
        return sb.toString();
    }
}
