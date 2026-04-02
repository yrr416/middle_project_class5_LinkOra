package org.study.project05class.dashboard.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05class.customer.vo.CustomerVO;
import org.study.project05class.dashboard.mapper.DashboardMapper;
import org.study.project05class.dashboard.vo.DashboardVO;
import org.study.project05class.dashboard.vo.RecentReserveVO;

import java.util.List;
import java.util.Map;

/**
 * 대시보드 서비스 구현체
 */
@Service
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private DashboardMapper dashboardMapper;

    /**
     * 대시보드 요약 카드 데이터를 DB에서 각각 조회하여 하나의 VO에 담아 반환
     * ⚠️ inquiry / report 테이블이 아직 없다면 setPendingInquiryCnt / setPendingReportCnt
     *    두 줄을 주석 처리하고 0으로 고정하세요.
     */
    @Override
    public DashboardVO getDashboardSummary() {
        DashboardVO vo = new DashboardVO();

        /* 예약 건수 */
        vo.setTodayReserveCnt(dashboardMapper.getTodayReserveCnt());
        vo.setYesterdayReserveCnt(dashboardMapper.getYesterdayReserveCnt());

        /* 회원 수 */
        vo.setTotalUserCnt(dashboardMapper.getTotalUserCnt());
        vo.setNewUserCnt(dashboardMapper.getNewUserCnt());

        /* 매출 */
        vo.setMonthlyRevenue(dashboardMapper.getMonthlyRevenue());

        /* 현재 이용 중 공간 */
        vo.setActiveSpaceCnt(dashboardMapper.getActiveSpaceCnt());

        /* 미처리 문의 (inquiries 테이블, i_status = 'PENDING') */
        vo.setPendingInquiryCnt(dashboardMapper.getPendingInquiryCnt());
        /* report 테이블 미존재 → 0 고정 (테이블 생성 후 쿼리로 교체) */
        vo.setPendingReportCnt(0);

        return vo;
    }

    /** 월별 매출 추이 */
    @Override
    public List<Map<String, Object>> getMonthlySales() {
        return dashboardMapper.getMonthlySales();
    }

    /** 공간별 이용률 */
    @Override
    public List<Map<String, Object>> getSpaceUsage() {
        return dashboardMapper.getSpaceUsage();
    }

    /** 요일별 예약 히트맵 */
    @Override
    public List<Map<String, Object>> getWeekdayHeatmap() {
        return dashboardMapper.getWeekdayHeatmap();
    }

    /** 최근 예약 5건 */
    @Override
    public List<RecentReserveVO> getRecentReserves() {
        return dashboardMapper.getRecentReserves();
    }

    /** 신규 가입 회원 목록 */
    @Override
    public List<CustomerVO> getNewUsers() {
        return dashboardMapper.getNewUsers();
    }
}
