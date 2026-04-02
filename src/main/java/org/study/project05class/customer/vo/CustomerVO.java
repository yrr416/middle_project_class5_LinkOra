package org.study.project05class.customer.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 회원(user) 테이블과 매핑되는 Value Object
 * 컬럼명을 실제 DB 컬럼과 동일하게 사용
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CustomerVO {

    private String u_idx;       // 회원 고유번호 (PK, AUTO_INCREMENT)
    private String u_id;        // 아이디
    private String u_role;      // 역할 (user / admin 등)
    private String u_name;      // 이름
    private String u_pwd;       // 비밀번호 (암호화 저장)
    private String u_email;     // 이메일
    private String u_addr;      // 주소
    private String u_phone;     // 전화번호
    private String u_created;   // 가입일
    private String u_active;    // 활성여부 (1: 정상, 0: 비활성)

    private String reserve_cnt; // 총 예약 건수 (조회용 - reservation 테이블 JOIN)

    // 검색 조건용 필드 (DB 컬럼 아님)
    private String search_type;   // 검색 유형 (name / email / phone)
    private String search_word;   // 검색어
    private String status_filter; // 상태 필터 (1: 정상, 0: 비활성, 전체: "")
}
