package org.study.project05class.reservation.vo;

import lombok.Data;

/**
 * 예약(reservation) 테이블 VO
 * - reservation + user + space + branch 조인 결과를 하나의 VO 에 담아 사용
 * - 하단 검색/필터 필드는 DB 컬럼이 아닌 화면 파라미터용
 */
@Data
public class ReservationVO {

    /* ── reservation 테이블 컬럼 ─────────────────────────── */

    /** 예약 고유 번호 (PK, AUTO_INCREMENT) */
    private int    r_idx;

    /** 공간 번호 (FK → space.s_idx) */
    private int    s_idx;

    /** 회원 번호 (FK → user.u_idx) */
    private int    u_idx;

    /** 예약 시작 일시 (DATETIME) */
    private String r_start_time;

    /** 예약 종료 일시 (DATETIME) */
    private String r_end_time;

    /**
     * 예약 내용/메모 (LONGTEXT)
     * ⚠️ 강제 취소 시 취소 사유를 이 필드에 저장합니다.
     *    (별도 취소 사유 컬럼이 없으므로 r_content 를 재사용)
     *    - 상태가 CANCELLED 일 때는 취소 사유로 표시
     *    - 그 외에는 예약 메모로 표시
     */
    private String r_content;

    /** 예약 인원 수 */
    private int    r_headcount;

    /** 예약 총 금액 (공간 단가 × 시간, 예약 시점 확정 금액) */
    private int    r_total_price;

    /** 예약 생성 일시 (DATETIME) */
    private String r_created;

    /** 예약 최종 수정 일시 (DATETIME) */
    private String r_updated;

    /**
     * 예약 상태 (ENUM)
     * PENDING   : 예약 대기 (기본값)
     * CONFIRMED : 예약 확정
     * USING     : 이용 중
     * COMPLETED : 이용 완료
     * CANCELLED : 취소
     */
    private String r_status;

    /* ── user 테이블 JOIN 컬럼 ───────────────────────────── */

    /** 예약자 이름 */
    private String u_name;

    /** 예약자 이메일 */
    private String u_email;

    /** 예약자 전화번호 */
    private String u_phone;

    /* ── space 테이블 JOIN 컬럼 ──────────────────────────── */

    /** 공간 이름 */
    private String s_name;

    /** 공간 유형 (ENUM: INDIVIDUAL, TEAM, CONFERENCE ...) */
    private String s_type;

    /** 공간 단가 (환불 금액 계산 시 참고용) */
    private int    s_price;

    /* ── branch 테이블 JOIN 컬럼 ─────────────────────────── */

    /** 지점 이름 */
    private String b_name;

    /* ── 검색·필터 파라미터 (DB 컬럼 아님) ──────────────── */

    /** 날짜 범위 시작일 (yyyy-MM-dd) */
    private String start_date;

    /** 날짜 범위 종료일 (yyyy-MM-dd) */
    private String end_date;

    /** 상태 필터 (PENDING / CONFIRMED / USING / COMPLETED / CANCELLED / 빈값=전체) */
    private String status_filter;

    /** 공간 필터 (space.s_idx, 빈값=전체) */
    private String space_filter;

    /** 고객명 검색어 */
    private String search_word;
}
