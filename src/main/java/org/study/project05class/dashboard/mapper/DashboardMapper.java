package org.study.project05class.dashboard.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05class.customer.vo.CustomerVO;
import org.study.project05class.dashboard.vo.RecentReserveVO;

import java.util.List;
import java.util.Map;

/**
 * 대시보드에서 사용하는 DB 조회 매퍼
 * SQL 정의: resources/mapper/DashboardMapper.xml
 */
@Mapper
public interface DashboardMapper {

    /* ── 요약 카드용 단일 수치 조회 ─────────────────────────── */

    /** 오늘 예약 건수 */
    int getTodayReserveCnt();

    /** 전일 예약 건수 */
    int getYesterdayReserveCnt();

    /** 전체 정상 회원 수 */
    int getTotalUserCnt();

    /** 이번달 신규 가입 회원 수 */
    int getNewUserCnt();

    /** 이번달 누적 매출 */
    long getMonthlyRevenue();

    /** 현재 이용 중인 공간 수 */
    int getActiveSpaceCnt();

    /** 미처리 문의 건수 (inquiries 테이블, i_status = 'PENDING') */
    int getPendingInquiryCnt();
    /* ⚠️ report 테이블 미존재 — getPendingReportCnt 는 서비스에서 0으로 고정 */

    /* ── 차트용 목록 조회 ─────────────────────────────────── */

    /**
     * 월별 매출 추이 (최근 6개월)
     * 반환 맵 키: month(String "yyyy-MM"), revenue(Long)
     */
    List<Map<String, Object>> getMonthlySales();

    /**
     * 공간별 이용률 (최근 3개월, 상위 8개)
     * 반환 맵 키: spacename(String), usagecount(Long)
     */
    List<Map<String, Object>> getSpaceUsage();

    /**
     * 요일별 예약 히트맵 (이번달 기준)
     * 반환 맵 키: weeknum(Integer), dayofweek(Integer 1~7), reservecnt(Long)
     */
    List<Map<String, Object>> getWeekdayHeatmap();

    /* ── 최근 현황 목록 조회 ──────────────────────────────── */

    /** 최근 예약 5건 (예약자·공간명·상태 포함) */
    List<RecentReserveVO> getRecentReserves();

    /** 신규 가입 회원 목록 (최근 5명) */
    List<CustomerVO> getNewUsers();
}
