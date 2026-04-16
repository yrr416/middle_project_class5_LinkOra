/**
 * 로그인 ID로 일반 회원(user) 또는 사업자(partner)를 조회해 UserDetails를 제공하는 서비스.
 */
package org.study.project05.login.config;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.member.vo.UserProfileVO;
import org.study.project05.partner.service.PartnerService;
import org.study.project05.partner.vo.PartnerVO;

@Service
public class CustomUserDetailsService implements UserDetailsService {
    private final UserProfileService userProfileService;
    private final PartnerService partnerService;
    private final org.study.project05.settings.mapper.SettingsMapper settingsMapper;

    public CustomUserDetailsService(UserProfileService userProfileService, PartnerService partnerService, org.study.project05.settings.mapper.SettingsMapper settingsMapper) {
        this.userProfileService = userProfileService;
        this.partnerService = partnerService;
        this.settingsMapper = settingsMapper;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        if (username == null || username.isBlank()) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다.");
        }
        String key = username.trim();

        // 1. 관리자 확인 (최우선)
        java.util.Map<String, Object> admin = settingsMapper.findAdminByLoginId(key);
        if (admin != null && admin.get("aPwd") != null) {
            String rawId = (String) admin.get("aId");
            String rawPwd = (String) admin.get("aPwd");
            // 관리자 비밀번호가 평문일 경우를 대비해 {noop} 지원 (Taemin 브랜치 전략 계승)
            String encodedPwd = rawPwd.startsWith("{") || rawPwd.startsWith("$2") ? rawPwd : "{noop}" + rawPwd;
            
            return new CustomUserDetails(
                    rawId,
                    encodedPwd,
                    java.util.Collections.singletonList(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_ADMIN")),
                    ((Number) admin.get("aIdx")).longValue(), // 관리자 PK
                    "관리자"
            );
        }

        // 2. 파트너 확인
        PartnerVO partner = partnerService.getByPartnerId(key);
        if (partner != null && partner.getPassword() != null && !partner.getPassword().isBlank()) {
            return new CustomUserDetails(
                    partner.getPartnerId(),
                    partner.getPassword(),
                    java.util.Collections.singletonList(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_PARTNER")),
                    (long) partner.getPtnIdx(),
                    partner.getName()
            );
        }

        UserProfileVO user = userProfileService.getByUserId(key);
        if (user != null && user.getPassword() != null) {
            return new CustomUserDetails(
                    user.getUserId(),
                    user.getPassword(),
                    java.util.Collections.singletonList(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_USER")),
                    (long) user.getUserIdx(),
                    user.getName()
            );
        }

        throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + key);
    }
}
