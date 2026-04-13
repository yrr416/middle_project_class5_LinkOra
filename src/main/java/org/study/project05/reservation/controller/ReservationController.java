package org.study.project05.reservation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.project05.reservation.service.ReservationService;
import org.study.project05.reservation.vo.ReservationVO;

import java.util.List;
import java.util.Map;

/**
 * 관리자 예약 관리 컨트롤러
 * 경로: /admin/reservation/**
 */
@Controller
@RequestMapping("/admin/reservation")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    private static final int NUM_PER_PAGE = 10;
    private static final int BLOCK_SIZE   = 5;

    /* 예약 목록 */
    @GetMapping({"/list", "", "/"})
    public String list(ReservationVO searchVO,
                       @RequestParam(defaultValue = "1") int nowPage,
                       Model model) {

        int total     = reservationService.getReservationCount(0, NUM_PER_PAGE, searchVO);
        int totalPage = Math.max(1, (int) Math.ceil((double) total / NUM_PER_PAGE));
        if (nowPage > totalPage) nowPage = totalPage;

        int offset     = (nowPage - 1) * NUM_PER_PAGE;
        int beginBlock = ((nowPage - 1) / BLOCK_SIZE) * BLOCK_SIZE + 1;
        int endBlock   = Math.min(beginBlock + BLOCK_SIZE - 1, totalPage);

        List<ReservationVO>  list    = reservationService.getReservationList(offset, NUM_PER_PAGE, searchVO);
        List<ReservationVO>  spaces  = reservationService.getSpaceListForFilter();
        Map<String, Integer> summary = reservationService.getStatusSummary(searchVO);

        model.addAttribute("reservationList", list);
        model.addAttribute("spaceList",       spaces);
        model.addAttribute("statusSummary",   summary);
        model.addAttribute("searchVO",        searchVO);
        model.addAttribute("totalRecord",     total);
        model.addAttribute("totalPage",       totalPage);
        model.addAttribute("nowPage",         nowPage);
        model.addAttribute("beginBlock",      beginBlock);
        model.addAttribute("endBlock",        endBlock);
        return "reservation/list";
    }

    /* 상세 페이지 (풀 페이지) */
    @GetMapping("/view")
    public String view(@RequestParam int resIdx,
                       @RequestParam(defaultValue = "1") int nowPage,
                       @ModelAttribute ReservationVO searchVO,
                       Model model) {
        ReservationVO rvo = reservationService.getReservationDetail(resIdx);
        List<ReservationVO> recentList = reservationService.getRecentReservationsByUser(rvo.getUserIdx(), resIdx);
        model.addAttribute("rvo",        rvo);
        model.addAttribute("recentList", recentList);
        model.addAttribute("nowPage",    nowPage);
        model.addAttribute("searchVO",   searchVO);
        return "reservation/detail";
    }

    /* 상세 조회 (AJAX - 기존 호환용) */
    @GetMapping("/detail")
    @ResponseBody
    public ReservationVO detail(@RequestParam int resIdx) {
        return reservationService.getReservationDetail(resIdx);
    }

    /* 예약 확정 */
    @PostMapping("/confirm")
    public String confirm(@RequestParam int resIdx,
                          @RequestParam(defaultValue = "1") int nowPage,
                          @RequestParam(defaultValue = "false") boolean fromDetail,
                          @ModelAttribute ReservationVO searchVO,
                          RedirectAttributes rttr) {
        reservationService.confirmReservation(resIdx);
        rttr.addFlashAttribute("alertMsg",  "예약이 확정되었습니다.");
        rttr.addFlashAttribute("alertType", "success");
        if (fromDetail) return "redirect:/admin/reservation/view?resIdx=" + resIdx + "&nowPage=" + nowPage + buildSearch(searchVO);
        return buildRedirect(nowPage, searchVO);
    }

    /* 이용 완료 */
    @PostMapping("/complete")
    public String complete(@RequestParam int resIdx,
                           @RequestParam(defaultValue = "1") int nowPage,
                           @RequestParam(defaultValue = "false") boolean fromDetail,
                           @ModelAttribute ReservationVO searchVO,
                           RedirectAttributes rttr) {
        reservationService.completeReservation(resIdx);
        rttr.addFlashAttribute("alertMsg",  "이용 완료 처리되었습니다.");
        rttr.addFlashAttribute("alertType", "success");
        if (fromDetail) return "redirect:/admin/reservation/view?resIdx=" + resIdx + "&nowPage=" + nowPage + buildSearch(searchVO);
        return buildRedirect(nowPage, searchVO);
    }

    /* 강제 취소 */
    @PostMapping("/cancel")
    public String cancel(@RequestParam int resIdx,
                         @RequestParam String cancelReason,
                         @RequestParam(defaultValue = "false") boolean refundChecked,
                         @RequestParam(defaultValue = "1") int nowPage,
                         @RequestParam(defaultValue = "false") boolean fromDetail,
                         @ModelAttribute ReservationVO searchVO,
                         RedirectAttributes rttr) {
        reservationService.cancelReservation(resIdx, cancelReason);
        String msg = refundChecked
                ? "예약이 취소되었습니다. (환불 처리 완료 확인)"
                : "예약이 취소되었습니다. 환불 처리를 별도로 진행해 주세요.";
        rttr.addFlashAttribute("alertMsg",  msg);
        rttr.addFlashAttribute("alertType", "warning");
        if (fromDetail) return "redirect:/admin/reservation/view?resIdx=" + resIdx + "&nowPage=" + nowPage + buildSearch(searchVO);
        return buildRedirect(nowPage, searchVO);
    }

    private String buildSearch(ReservationVO vo) {
        StringBuilder sb = new StringBuilder();
        if (vo.getStartDate()    != null && !vo.getStartDate().isEmpty())    sb.append("&startDate=").append(vo.getStartDate());
        if (vo.getEndDate()      != null && !vo.getEndDate().isEmpty())      sb.append("&endDate=").append(vo.getEndDate());
        if (vo.getStatusFilter() != null && !vo.getStatusFilter().isEmpty()) sb.append("&statusFilter=").append(vo.getStatusFilter());
        if (vo.getSpaceFilter()  != null && !vo.getSpaceFilter().isEmpty())  sb.append("&spaceFilter=").append(vo.getSpaceFilter());
        if (vo.getSearchWord()   != null && !vo.getSearchWord().isEmpty())   sb.append("&searchWord=").append(vo.getSearchWord());
        return sb.toString();
    }

    private String buildRedirect(int nowPage, ReservationVO vo) {
        return "redirect:/admin/reservation/list?nowPage=" + nowPage + buildSearch(vo);
    }
}
