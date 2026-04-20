/**
 * 로그인 ID로 일반 회원(user) 또는 사업자(partner)를 조회해 UserDetails를 제공하는 서비스.
 */
package org.study.project05.login.config;


import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.study.project05.member.service.UserProfileService;
import org.study.project05.member.vo.UserProfileVO;
import org.study.project05.partner.service.PartnerService;
import org.study.project05.partner.vo.PartnerVO;
import org.study.project05.settings.mapper.SettingsMapper;

import java.util.Map;

@Service
public class CustomUserDetailsService implements UserDetailsService {
    private final UserProfileService userProfileService;
    private final PartnerService partnerService;
    private final SettingsMapper settingsMapper;

    public CustomUserDetailsService(UserProfileService userProfileService, PartnerService partnerService, SettingsMapper settingsMapper) {
        this.userProfileService = userProfileService;
        this.partnerService = partnerService;
        this.settingsMapper = settingsMapper;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        if (username == null || username.isBlank()) {
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다.");
        }
        String key = username.strip();

        // 관리자 테이블 먼저 확인
        Map<String, Object> admin = settingsMapper.findAdminByLoginId(key);
        if (admin != null && admin.get("aPwd") != null) {
            String rawId  = (String) admin.get("aId");
            String rawPwd = ((String) admin.get("aPwd")).strip();
            // 평문이면 {noop} 접두사 추가, bcrypt·delegating 형식이면 그대로 사용
            String encodedPwd = (rawPwd.startsWith("{") || rawPwd.startsWith("$2"))
                    ? rawPwd : "{noop}" + rawPwd;
            return new CustomUserDetails(
                    rawId,
                    encodedPwd,
                    java.util.Collections.singletonList(
                            new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_ADMIN")),
                    ((Number) admin.get("aIdx")).longValue(),
                    "관리자"
            );
        }

        // 일반 회원을 먼저 조회 (p_id=u_id인 레거시가 있으면 파트너를 먼저 보면 잘못된 비밀번호로 검증됨)
        UserProfileVO user = userProfileService.getByUserId(key);
        String userEncoded = user != null && user.getPassword() != null ? user.getPassword().strip() : "";
        if (user != null && !userEncoded.isEmpty()) {

            if (Integer.valueOf(0).equals(user.getActive())) {
                throw new DisabledException("탈퇴 처리된 회원 계정입니다.");
            }
            return new CustomUserDetails(
                    user.getUserId(),
                    userEncoded,
                    java.util.Collections.singletonList(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_USER")),
                    (long) user.getUserIdx(),
                    user.getName()
            );
        }

        PartnerVO partner = partnerService.getByPartnerId(key);
        String partnerEncoded = partner != null && partner.getPassword() != null
                ? partner.getPassword().strip()
                : "";
        if (partner != null && !partnerEncoded.isEmpty()) {
            if (Integer.valueOf(0).equals(partner.getActive())) {
                throw new DisabledException("탈퇴 처리된 사업자 계정입니다.");
            }
            return new CustomUserDetails(
                    partner.getPartnerId(),
                    partnerEncoded,
                    java.util.Collections.singletonList(new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_PARTNER")),
                    (long) partner.getPtnIdx(),
                    partner.getName()
            );
        }

        throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + key);
    }
}
