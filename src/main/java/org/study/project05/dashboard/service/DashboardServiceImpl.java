package org.study.project05.dashboard.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.customer.vo.CustomerVO;
import org.study.project05.dashboard.mapper.DashboardMapper;
import org.study.project05.dashboard.vo.DashboardVO;
import org.study.project05.dashboard.vo.RecentReserveVO;

import java.util.List;
import java.util.Map;

@Service
public class DashboardServiceImpl implements DashboardService {

    @Autowired
    private DashboardMapper dashboardMapper;

    @Override
    public DashboardVO getDashboardSummary() {
        DashboardVO vo = new DashboardVO();
        vo.setTodayReserveCnt(dashboardMapper.getTodayReserveCnt());
        vo.setYesterdayReserveCnt(dashboardMapper.getYesterdayReserveCnt());
        vo.setTotalUserCnt(dashboardMapper.getTotalUserCnt());
        vo.setNewUserCnt(dashboardMapper.getNewUserCnt());
        vo.setMonthlyRevenue(dashboardMapper.getMonthlyRevenue());
        vo.setActiveSpaceCnt(dashboardMapper.getActiveSpaceCnt());
        vo.setPendingInquiryCnt(dashboardMapper.getPendingInquiryCnt());
        vo.setPendingReportCnt(0); /* report 테이블 미존재 */
        return vo;
    }

    @Override public List<Map<String, Object>> getMonthlySales()   { return dashboardMapper.getMonthlySales(); }
    @Override public List<Map<String, Object>> getSpaceUsage()     { return dashboardMapper.getSpaceUsage(); }
    @Override public List<Map<String, Object>> getWeekdayHeatmap() { return dashboardMapper.getWeekdayHeatmap(); }
    @Override public List<RecentReserveVO>     getRecentReserves() { return dashboardMapper.getRecentReserves(); }
    @Override public List<CustomerVO>          getNewUsers()       { return dashboardMapper.getNewUsers(); }
}
