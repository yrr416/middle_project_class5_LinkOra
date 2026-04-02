package org.study.project05class.dashboard.vo;

import lombok.Data;

/**
 * 대시보드 '최근 예약 5건' 목록에 사용하는 VO
 * reservation + user + space 테이블을 JOIN하여 조회
 */
@Data
public class RecentReserveVO {

    /* 예약 번호 (reservation.r_idx) */
    private String r_idx;

    /* 예약자 이름 (user.u_name) */
    private String u_name;

    /* 공간 이름 (space.s_name) */
    private String s_name;

    /* 예약일 (reservation.r_date) */
    private String r_date;

    /* 예약 상태 (reservation.r_status) — 예: '예약', '이용중', '완료', '취소' */
    private String r_status;

    /* 예약 금액 — space.s_price 값을 문자열로 담아 화면에 표시 */
    private String r_price;
}
