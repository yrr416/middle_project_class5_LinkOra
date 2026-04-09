package org.study.project05.dashboard.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.study.project05.customer.vo.CustomerVO;
import org.study.project05.dashboard.service.DashboardService;
import org.study.project05.dashboard.vo.DashboardVO;
import org.study.project05.dashboard.vo.RecentReserveVO;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * 관리자 대시보드 컨트롤러
 * 경로: /admin/dashboard
 */
@Controller
@RequestMapping("/admin/dashboard")
public class DashboardController {

    @Autowired private DashboardService dashboardService;
    @Autowired private ObjectMapper     objectMapper;

    @GetMapping({"", "/"})
    public String dashboard(Model model) throws JsonProcessingException {

        /* ① 요약 카드 */
        DashboardVO summary = dashboardService.getDashboardSummary();
        model.addAttribute("summary", summary);

        /* 전일 대비 변화율 계산 */
        int today = summary.getTodayReserveCnt(), yesterday = summary.getYesterdayReserveCnt();
        double rate = yesterday > 0 ? (double)(today - yesterday) / yesterday * 100
                    : today > 0    ? 100.0 : 0.0;
        model.addAttribute("reserveChangeRate", Math.round(rate * 10.0) / 10.0);

        /* ② 월별 매출 (최근 6개월, 빈 달은 0으로 채움) */
        Map<String, Long> salesMap = new HashMap<>();
        for (Map<String, Object> r : dashboardService.getMonthlySales())
            salesMap.put((String) r.get("month"), ((Number) r.get("revenue")).longValue());

        List<String> monthLabels = new ArrayList<>();
        List<Long>   monthRevs   = new ArrayList<>();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM");
        for (int i = 5; i >= 0; i--) {
            String m = LocalDate.now().minusMonths(i).format(fmt);
            monthLabels.add(m);
            monthRevs.add(salesMap.getOrDefault(m, 0L));
        }
        model.addAttribute("monthLabelsJson",   objectMapper.writeValueAsString(monthLabels));
        model.addAttribute("monthRevenuesJson", objectMapper.writeValueAsString(monthRevs));

        /* ③ 공간별 이용률 도넛 */
        List<Map<String, Object>> spaceUsage = dashboardService.getSpaceUsage();
        model.addAttribute("spaceLabelsJson", objectMapper.writeValueAsString(
                spaceUsage.stream().map(m -> m.get("spacename")).toList()));
        model.addAttribute("spaceCountsJson", objectMapper.writeValueAsString(
                spaceUsage.stream().map(m -> m.get("usagecount")).toList()));

        /* ④ 요일별 히트맵 */
        model.addAttribute("heatmapJson",
                objectMapper.writeValueAsString(dashboardService.getWeekdayHeatmap()));

        /* ⑤ 최근 현황 */
        List<RecentReserveVO> recentReserves = dashboardService.getRecentReserves();
        List<CustomerVO>      newUsers        = dashboardService.getNewUsers();
        model.addAttribute("recentReserves", recentReserves);
        model.addAttribute("newUsers",       newUsers);

        return "admin/dashboard";
    }
}
