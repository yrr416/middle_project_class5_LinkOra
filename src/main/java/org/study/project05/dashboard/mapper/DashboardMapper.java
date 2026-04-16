package org.study.project05.dashboard.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05.customer.vo.CustomerVO;
import org.study.project05.dashboard.vo.RecentReserveVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface DashboardMapper {

    int getTodayReserveCnt();
    int getYesterdayReserveCnt();
    int getTotalUserCnt();
    int getNewUserCnt();
    long getMonthlyRevenue();
    int getActiveSpaceCnt();
    int getPendingInquiryCnt();

    List<Map<String, Object>> getMonthlySales();
    List<Map<String, Object>> getSpaceUsage();
    List<Map<String, Object>> getWeekdayHeatmap();

    List<RecentReserveVO> getRecentReserves();
    List<CustomerVO>      getNewUsers();
}
