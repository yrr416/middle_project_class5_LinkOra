package org.study.project05class.dashboard.service;

import org.study.project05class.customer.vo.CustomerVO;
import org.study.project05class.dashboard.vo.DashboardVO;
import org.study.project05class.dashboard.vo.RecentReserveVO;

import java.util.List;
import java.util.Map;

/**
 * 대시보드 서비스 인터페이스
 */
public interface DashboardService {

    /** 대시보드 상단 요약 카드 데이터 조회 */
    DashboardVO getDashboardSummary();

    /** 월별 매출 추이 데이터 조회 (최근 6개월) */
    List<Map<String, Object>> getMonthlySales();

    /** 공간별 이용률 데이터 조회 */
    List<Map<String, Object>> getSpaceUsage();

    /** 요일별 예약 히트맵 데이터 조회 */
    List<Map<String, Object>> getWeekdayHeatmap();

    /** 최근 예약 5건 조회 */
    List<RecentReserveVO> getRecentReserves();

    /** 신규 가입 회원 목록 조회 (최근 5명) */
    List<CustomerVO> getNewUsers();
}
