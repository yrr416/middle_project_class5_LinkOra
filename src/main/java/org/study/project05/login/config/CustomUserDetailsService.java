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
        String key = username.trim();

        // 관리자 테이블 먼저 확인
        Map<String, Object> admin = settingsMapper.findAdminByLoginId(key);
        if (admin != null && admin.get("aPwd") != null) {
            String rawPwd = (String) admin.get("aPwd");
            return User.withUsername((String) admin.get("aId"))
                    .password("{noop}" + rawPwd)
                    .roles("ADMIN")
                    .build();
        }

        PartnerVO partner = partnerService.getByPartnerId(key);
        if (partner != null && partner.getPassword() != null && !partner.getPassword().isBlank()) {
            return User.withUsername(partner.getPartnerId())
                    .password(partner.getPassword())
                    .roles("PARTNER")
                    .build();
        }

        UserProfileVO user = userProfileService.getByUserId(key);
        if (user != null && user.getPassword() != null) {
            return User.withUsername(user.getUserId())
                    .password(user.getPassword())
                    .roles("USER")
                    .build();
        }

        throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + key);
    }
}
