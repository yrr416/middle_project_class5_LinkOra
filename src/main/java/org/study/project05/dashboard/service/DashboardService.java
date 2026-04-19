package org.study.project05.dashboard.service;

import org.study.project05.customer.vo.CustomerVO;
import org.study.project05.dashboard.vo.DashboardVO;
import org.study.project05.dashboard.vo.RecentReserveVO;

import java.util.List;
import java.util.Map;

public interface DashboardService {
    DashboardVO getDashboardSummary();
    List<Map<String, Object>> getMonthlySales();
    List<Map<String, Object>> getSpaceUsage();
    List<Map<String, Object>> getWeekdayHeatmap();
    List<RecentReserveVO> getRecentReserves();
    List<CustomerVO>      getNewUsers();
}
