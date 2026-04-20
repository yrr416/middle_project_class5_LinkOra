/**
 * partner 테이블 컬럼과 매핑되는 사업자 값 객체(사업자번호·연락처·프로필 등).
 */
package org.study.project05.partner.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class PartnerVO {
    private int ptnIdx;
    private String partnerId;
    private String password;
    private String name;
    private String email;
    private String address;
    private String phone;
    private String businessNo;
    private String profileImage;
    private Integer active;
}
