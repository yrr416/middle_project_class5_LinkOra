package org.study.project05class.dashboard.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.study.project05class.customer.vo.CustomerVO;
import org.study.project05class.dashboard.service.DashboardService;
import org.study.project05class.dashboard.vo.DashboardVO;
import org.study.project05class.dashboard.vo.RecentReserveVO;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 관리자 대시보드 컨트롤러
 * 요청 경로: /admin/dashboard
 * 뷰 경로  : /WEB-INF/views/admin/dashboard.jsp
 */
@Controller
@RequestMapping("/admin/dashboard")
public class DashboardController {

    /* 대시보드 비즈니스 로직 */
    @Autowired
    private DashboardService dashboardService;

    /* 차트 데이터를 JSON 문자열로 직렬화하기 위한 Jackson ObjectMapper */
    @Autowired
    private ObjectMapper objectMapper;

    /**
     * 대시보드 메인 페이지
     * - 요약 카드 4개 (예약·회원·매출·공간)
     * - 월별 매출 막대 그래프 / 공간별 이용률 도넛 차트 / 요일별 히트맵
     * - 최근 예약 5건 / 미처리 알림 / 신규 가입 회원 목록
     */
    @GetMapping({"", "/"})
    public String dashboard(Model model) throws JsonProcessingException {

        /* ────────────────────────────────────────
           ① 요약 카드 데이터
           ──────────────────────────────────────── */
        DashboardVO summary = dashboardService.getDashboardSummary();
        model.addAttribute("summary", summary);

        /* 오늘 예약 건수의 전일 대비 변화율(%) 계산 */
        int today     = summary.getTodayReserveCnt();
        int yesterday = summary.getYesterdayReserveCnt();
        double changeRate = 0.0;
        if (yesterday > 0) {
            /* 일반적인 증감률 공식: (오늘 - 전일) / 전일 × 100 */
            changeRate = (double) (today - yesterday) / yesterday * 100.0;
        } else if (today > 0) {
            /* 전일이 0건인데 오늘 예약이 있으면 +100% 로 표기 */
            changeRate = 100.0;
        }
        /* 소수점 첫째 자리까지 반올림하여 모델에 전달 */
        model.addAttribute("reserveChangeRate", Math.round(changeRate * 10.0) / 10.0);

        /* ────────────────────────────────────────
           ② 월별 매출 추이 차트 데이터
              - DB에서 조회한 결과에 없는 달은 0으로 채워 6개월 레이블을 고정
           ──────────────────────────────────────── */
        List<Map<String, Object>> salesRaw = dashboardService.getMonthlySales();

        /* 조회 결과를 "yyyy-MM" → 매출액 맵으로 변환 */
        Map<String, Long> salesMap = new HashMap<>();
        for (Map<String, Object> row : salesRaw) {
            salesMap.put(
                (String) row.get("month"),
                ((Number) row.get("revenue")).longValue()
            );
        }

        /* 최근 6개월 레이블·매출 리스트 생성 (오래된 달 → 최신 달 순) */
        List<String> monthLabels   = new ArrayList<>();
        List<Long>   monthRevenues = new ArrayList<>();
        LocalDate    now           = LocalDate.now();
        DateTimeFormatter fmt      = DateTimeFormatter.ofPattern("yyyy-MM");
        for (int i = 5; i >= 0; i--) {
            String m = now.minusMonths(i).format(fmt);
            monthLabels.add(m);
            monthRevenues.add(salesMap.getOrDefault(m, 0L));
        }
        /* Chart.js에서 사용할 JSON 문자열로 직렬화 */
        model.addAttribute("monthLabelsJson",   objectMapper.writeValueAsString(monthLabels));
        model.addAttribute("monthRevenuesJson", objectMapper.writeValueAsString(monthRevenues));

        /* ────────────────────────────────────────
           ③ 공간별 이용률 도넛 차트 데이터
           ──────────────────────────────────────── */
        List<Map<String, Object>> spaceUsage = dashboardService.getSpaceUsage();

        /* 공간명 레이블 목록 */
        List<Object> spaceLabels = spaceUsage.stream()
                .map(m -> m.get("spacename"))
                .toList();
        /* 이용 건수 목록 */
        List<Object> spaceCounts = spaceUsage.stream()
                .map(m -> m.get("usagecount"))
                .toList();
        model.addAttribute("spaceLabelsJson", objectMapper.writeValueAsString(spaceLabels));
        model.addAttribute("spaceCountsJson", objectMapper.writeValueAsString(spaceCounts));

        /* ────────────────────────────────────────
           ④ 요일별 예약 히트맵 데이터
              - weeknum(1~6), dayofweek(1~7), reservecnt 를 JSON으로 전달
              - JSP 내 JavaScript에서 달력 그리드를 렌더링
           ──────────────────────────────────────── */
        List<Map<String, Object>> heatmapData = dashboardService.getWeekdayHeatmap();
        model.addAttribute("heatmapJson", objectMapper.writeValueAsString(heatmapData));

        /* ────────────────────────────────────────
           ⑤ 최근 예약 5건
           ──────────────────────────────────────── */
        List<RecentReserveVO> recentReserves = dashboardService.getRecentReserves();
        model.addAttribute("recentReserves", recentReserves);

        /* ────────────────────────────────────────
           ⑥ 신규 가입 회원 목록 (최근 5명)
           ──────────────────────────────────────── */
        List<CustomerVO> newUsers = dashboardService.getNewUsers();
        model.addAttribute("newUsers", newUsers);

        /* 뷰 반환: /WEB-INF/views/admin/dashboard.jsp */
        return "admin/dashboard";
    }
}
