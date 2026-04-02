package org.study.project05class.dashboard.vo;

import lombok.Data;

/**
 * 대시보드 상단 요약 카드에 표시할 수치 데이터 VO
 */
@Data
public class DashboardVO {

    /* 오늘 예약 건수 */
    private int todayReserveCnt;

    /* 전일(어제) 예약 건수 — 전일 대비 변화율 계산에 사용 */
    private int yesterdayReserveCnt;

    /* 전체 정상 회원 수 (숨김 제외) */
    private int totalUserCnt;

    /* 이번달 신규 가입 회원 수 */
    private int newUserCnt;

    /* 이번달 누적 매출 (space.s_price 기준 합산) */
    private long monthlyRevenue;

    /* 현재 이용 중인 공간 수 (r_status = '이용중' 기준) */
    private int activeSpaceCnt;

    /* 미처리 문의 건수 (inquiry 테이블 i_status = 0) */
    private int pendingInquiryCnt;

    /* 처리 대기 신고 건수 (report 테이블 미존재로 현재 0 고정) */
    private int pendingReportCnt;
}
