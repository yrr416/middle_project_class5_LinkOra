package org.study.project05.customer.vo;

import lombok.Data;

/**
 * 회원(user) 테이블 VO + 검색 파라미터
 * camelCase 필드명 사용 (MyBatis map-underscore-to-camel-case 자동 매핑)
 */
@Data
public class CustomerVO {

    /* ── user 테이블 컬럼 ── */
    private String userIdx;       // 회원 고유번호 (PK)
    private String userId;        // 아이디
    private String userRole;      // 역할 (user/admin/vip)
    private String userName;      // 이름
    private String userPwd;       // 비밀번호
    private String userEmail;     // 이메일
    private String userAddr;      // 주소
    private String userPhone;     // 전화번호
    private String userCreated;   // 가입일
    private String userActive;    // 활성 상태 (0=정상, 1=숨김)

    /* ── 조인 필드 ── */
    private String reserveCnt;    // 예약 건수 (reservation 서브쿼리)

    /* ── 검색 파라미터 (DB 컬럼 아님) ── */
    private String searchType;    // 검색 항목 (name/email/phone)
    private String searchWord;    // 검색어
    private String statusFilter;  // 상태 필터 (0=정상, 1=숨김)
}
