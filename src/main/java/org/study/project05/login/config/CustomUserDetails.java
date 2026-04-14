package org.study.project05.login.config;

import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;

/**
 * CustomUserDetails: Spring Security의 User를 확장하여
 * DB의 기본키(userIdx 또는 partnerIdx)를 가질 수 있게 함.
 */
@Getter
public class CustomUserDetails extends User {

    private final Long idx; // 회원의 u_idx 또는 사업자의 p_idx
    private final String realName; // 실제 이름 (선택 사항)

    public CustomUserDetails(String username, String password, Collection<? extends GrantedAuthority> authorities, Long idx, String realName) {
        super(username, password, authorities);
        this.idx = idx;
        this.realName = realName;
    }
}
