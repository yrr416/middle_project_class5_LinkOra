package org.study.project05.dashboard.vo;

import lombok.Data;

@Data
public class DashboardVO {
    private int  todayReserveCnt;
    private int  yesterdayReserveCnt;
    private int  totalUserCnt;
    private int  newUserCnt;
    private long monthlyRevenue;
    private int  activeSpaceCnt;
    private int  pendingInquiryCnt;
    /** report 테이블 미존재로 현재 0 고정 */
    private int  pendingReportCnt;
}
