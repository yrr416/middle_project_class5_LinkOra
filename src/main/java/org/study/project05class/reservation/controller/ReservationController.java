package org.study.project05class.reservation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.project05class.reservation.service.ReservationService;
import org.study.project05class.reservation.vo.ReservationVO;

import java.util.List;
import java.util.Map;

/**
 * 관리자 예약 관리 컨트롤러
 * 요청 경로: /admin/reservation/**
 * 뷰 경로  : /WEB-INF/views/reservation/list.jsp
 */
@Controller
@RequestMapping("/admin/reservation")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    /* 페이지당 표시 건수 */
    private static final int NUM_PER_PAGE = 10;
    /* 페이지 블록 크기 (하단 페이징 번호 개수) */
    private static final int BLOCK_SIZE   = 5;

    /**
     * 예약 목록 페이지
     * - 날짜 범위·상태·공간·고객명 필터 적용
     * - 페이징 처리
     *
     * @param searchVO  검색·필터 파라미터 (start_date, end_date, status_filter, space_filter, search_word)
     * @param nowPage   현재 페이지 번호 (기본값 1)
     */
    @GetMapping({"/list","", "/"})
    public String list(ReservationVO searchVO,
                       @RequestParam(defaultValue = "1") int nowPage,
                       Model model,
                       RedirectAttributes rttr) {

        /* ── 페이징 계산 ───────────────────────────────── */
        int offset     = (nowPage - 1) * NUM_PER_PAGE;
        int totalRecord = reservationService.getReservationCount(offset, NUM_PER_PAGE, searchVO);
        int totalPage   = (totalRecord == 0) ? 1 : (int) Math.ceil((double) totalRecord / NUM_PER_PAGE);

        /* 페이지 범위 초과 시 마지막 페이지로 보정 */
        if (nowPage > totalPage) nowPage = totalPage;

        /* 페이지 블록 (ex: [1 2 3 4 5] / [6 7 8 9 10]) */
        int beginBlock = ((nowPage - 1) / BLOCK_SIZE) * BLOCK_SIZE + 1;
        int endBlock   = Math.min(beginBlock + BLOCK_SIZE - 1, totalPage);

        /* ── 예약 목록 조회 ─────────────────────────────── */
        offset = (nowPage - 1) * NUM_PER_PAGE; // 보정 후 재계산
        List<ReservationVO> reservationList =
                reservationService.getReservationList(offset, NUM_PER_PAGE, searchVO);

        /* ── 공간 드롭다운 목록 (필터용) ───────────────── */
        List<ReservationVO> spaceList = reservationService.getSpaceListForFilter();

        /* ── 상태별 건수 (통계 카드) ─────────────────────
           날짜·공간 필터만 적용, 상태 필터 무시 → 전체 상태 현황 표시 */
        Map<String, Integer> statusSummary = reservationService.getStatusSummary(searchVO);

        /* ── 모델에 데이터 담기 ──────────────────────────── */
        model.addAttribute("reservationList", reservationList);
        model.addAttribute("spaceList",       spaceList);
        model.addAttribute("searchVO",        searchVO);
        model.addAttribute("statusSummary",   statusSummary);
        model.addAttribute("totalRecord",     totalRecord);
        model.addAttribute("totalPage",       totalPage);
        model.addAttribute("nowPage",         nowPage);
        model.addAttribute("beginBlock",      beginBlock);
        model.addAttribute("endBlock",        endBlock);

        return "reservation/list"; /* → /WEB-INF/views/reservation/list.jsp */
    }

    /**
     * 예약 상세 조회 (AJAX — JSON 반환)
     * 목록 행 클릭 시 모달로 호출, Jackson 이 ReservationVO → JSON 직렬화
     *
     * @param r_idx 예약 번호
     */
    @GetMapping("/detail")
    @ResponseBody
    public ReservationVO detail(@RequestParam int r_idx) {
        return reservationService.getReservationDetail(r_idx);
    }

    /**
     * 예약 확정 처리 (PENDING → CONFIRMED)
     * 처리 후 목록 페이지로 리다이렉트, 성공 메시지 전달
     */
    @PostMapping("/confirm")
    public String confirm(@RequestParam int    r_idx,
                          @RequestParam(defaultValue = "1") int nowPage,
                          @ModelAttribute ReservationVO searchVO,
                          RedirectAttributes rttr) {

        reservationService.confirmReservation(r_idx);

        rttr.addFlashAttribute("alertMsg",  "예약이 확정되었습니다.");
        rttr.addFlashAttribute("alertType", "success");

        /* 현재 필터 상태를 유지하며 목록으로 돌아가기 */
        return buildRedirect(nowPage, searchVO);
    }

    /**
     * 이용 완료 처리 (CONFIRMED / USING → COMPLETED)
     */
    @PostMapping("/complete")
    public String complete(@RequestParam int r_idx,
                           @RequestParam(defaultValue = "1") int nowPage,
                           @ModelAttribute ReservationVO searchVO,
                           RedirectAttributes rttr) {

        reservationService.completeReservation(r_idx);

        rttr.addFlashAttribute("alertMsg",  "이용 완료 처리되었습니다.");
        rttr.addFlashAttribute("alertType", "success");

        return buildRedirect(nowPage, searchVO);
    }

    /**
     * 강제 취소 처리 (→ CANCELLED)
     * - 취소 사유(cancel_reason)를 reservation.r_content 에 저장
     * - 환불 처리 여부(refund_checked)는 UI 확인용이며
     *   실제 결제 시스템 연동이 필요한 경우 여기에 추가 로직을 작성하세요.
     *
     * @param cancel_reason   취소 사유 (필수)
     * @param refund_checked  환불 처리 완료 체크 여부 (UI 확인용)
     */
    @PostMapping("/cancel")
    public String cancel(@RequestParam int     r_idx,
                         @RequestParam String  cancel_reason,
                         @RequestParam(defaultValue = "false") boolean refund_checked,
                         @RequestParam(defaultValue = "1") int nowPage,
                         @ModelAttribute ReservationVO searchVO,
                         RedirectAttributes rttr) {

        reservationService.cancelReservation(r_idx, cancel_reason);

        /* 환불 처리 완료 체크 여부에 따라 메시지 분기 */
        String msg = refund_checked
                ? "예약이 취소되었습니다. (환불 처리 완료 확인)"
                : "예약이 취소되었습니다. 환불 처리를 별도로 진행해 주세요.";
        rttr.addFlashAttribute("alertMsg",  msg);
        rttr.addFlashAttribute("alertType", "warning");

        return buildRedirect(nowPage, searchVO);
    }

    /* ── 내부 헬퍼 ─────────────────────────────────────── */

    /**
     * 목록으로 리다이렉트 URL 생성
     * 현재 검색·필터 파라미터를 쿼리스트링으로 유지
     */
    private String buildRedirect(int nowPage, ReservationVO vo) {
        StringBuilder sb = new StringBuilder("redirect:/admin/reservation/list?nowPage=")
                .append(nowPage);
        if (vo.getStart_date()    != null && !vo.getStart_date().isEmpty())
            sb.append("&start_date=").append(vo.getStart_date());
        if (vo.getEnd_date()      != null && !vo.getEnd_date().isEmpty())
            sb.append("&end_date=").append(vo.getEnd_date());
        if (vo.getStatus_filter() != null && !vo.getStatus_filter().isEmpty())
            sb.append("&status_filter=").append(vo.getStatus_filter());
        if (vo.getSpace_filter()  != null && !vo.getSpace_filter().isEmpty())
            sb.append("&space_filter=").append(vo.getSpace_filter());
        if (vo.getSearch_word()   != null && !vo.getSearch_word().isEmpty())
            sb.append("&search_word=").append(vo.getSearch_word());
        return sb.toString();
    }
}
