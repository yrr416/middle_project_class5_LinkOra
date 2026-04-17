package org.study.project05.partner.reservation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.project05.partner.reservation.service.PartnerReservationService;
import org.study.project05.partner.reservation.vo.PartnerReservationVO;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/partner/reservation")
public class PartnerReservationController {

    @Autowired
    private PartnerReservationService service;

    /** TODO: 파트너 로그인 구현 후 인증 처리 필요 */
    private int getPartnerIdx(HttpSession session) {
        Object val = session.getAttribute("partnerIdx");
        // Integer, Long 등 어떤 숫자 타입으로 저장되어 있어도 안전하게 int로 변환
        return (val instanceof Number) ? ((Number) val).intValue() : 1;
    }

    /* ──────────────────────────────────────────────────────────
       GET /partner/reservation/list
       ────────────────────────────────────────────────────────── */
    @GetMapping("/list")
    public String list(
            @RequestParam(defaultValue = "1")  int    nowPage,
            @RequestParam(defaultValue = "10") int    numPerPage,
            @RequestParam(defaultValue = "list") String tab,
            PartnerReservationVO searchVO,
            HttpSession session,
            Model model
    ) {
        // numPerPage 허용값 검증 (10/20/50만 허용)
        if (numPerPage != 10 && numPerPage != 20 && numPerPage != 50) {
            numPerPage = 10;
        }

        int partnerIdx  = getPartnerIdx(session);
        int BLOCK_SIZE  = 5;
        int offset      = (nowPage - 1) * numPerPage;

        int totalRecord = service.getCount(partnerIdx, offset, numPerPage, searchVO);
        int totalPage   = (totalRecord == 0) ? 1 : (int) Math.ceil((double) totalRecord / numPerPage);
        if (nowPage > totalPage) nowPage = totalPage;

        int beginBlock = ((nowPage - 1) / BLOCK_SIZE) * BLOCK_SIZE + 1;
        int endBlock   = Math.min(beginBlock + BLOCK_SIZE - 1, totalPage);

        offset = (nowPage - 1) * numPerPage;

        List<PartnerReservationVO> list      = service.getList(partnerIdx, offset, numPerPage, searchVO);
        List<PartnerReservationVO> spaceList = service.getSpaceList(partnerIdx);
        Map<String, Object>        summary   = service.getSummary(partnerIdx);

        model.addAttribute("summary",     summary);
        model.addAttribute("list",        list);
        model.addAttribute("spaceList",   spaceList);
        model.addAttribute("totalRecord", totalRecord);
        model.addAttribute("totalPage",   totalPage);
        model.addAttribute("nowPage",     nowPage);
        model.addAttribute("beginBlock",  beginBlock);
        model.addAttribute("endBlock",    endBlock);
        model.addAttribute("numPerPage",  numPerPage);
        model.addAttribute("searchVO",    searchVO);
        model.addAttribute("tab",         tab);

        return "partner/reservation/list";
    }

    /* ──────────────────────────────────────────────────────────
       GET /partner/reservation/detail  (@ResponseBody)
       ────────────────────────────────────────────────────────── */
    @GetMapping("/detail")
    @ResponseBody
    public ResponseEntity<?> detail(
            @RequestParam int resIdx,
            HttpSession session
    ) {
        int partnerIdx = getPartnerIdx(session);
        PartnerReservationVO detail = service.getDetail(resIdx, partnerIdx);
        if (detail == null) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body("접근 권한이 없거나 존재하지 않는 예약입니다.");
        }
        return ResponseEntity.ok(detail);
    }

    /* ──────────────────────────────────────────────────────────
       GET /partner/reservation/calendar  (@ResponseBody)
       ────────────────────────────────────────────────────────── */
    @GetMapping("/calendar")
    @ResponseBody
    public List<Map<String, Object>> calendar(
            @RequestParam int year,
            @RequestParam int month,
            HttpSession session
    ) {
        int partnerIdx = getPartnerIdx(session);
        return service.getCalendarEvents(partnerIdx, year, month);
    }

    /* ──────────────────────────────────────────────────────────
       POST /partner/reservation/confirm  (@ResponseBody AJAX)
       ────────────────────────────────────────────────────────── */
    @PostMapping("/confirm")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> confirm(
            @RequestParam int resIdx,
            HttpSession session
    ) {
        int partnerIdx = getPartnerIdx(session);
        boolean ok = service.confirmReservation(resIdx, partnerIdx);
        Map<String, Object> body = new java.util.HashMap<>();
        body.put("success", ok);
        body.put("message", ok ? "예약이 수락되었습니다." : "수락 처리에 실패했습니다. (이미 처리됐거나 권한 없음)");
        return ok ? ResponseEntity.ok(body)
                  : ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    /* ──────────────────────────────────────────────────────────
       POST /partner/reservation/reject  (@ResponseBody AJAX)
       ────────────────────────────────────────────────────────── */
    @PostMapping("/reject")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> reject(
            @RequestParam int resIdx,
            @RequestParam(defaultValue = "") String reason,
            HttpSession session
    ) {
        int partnerIdx = getPartnerIdx(session);
        boolean ok = service.rejectReservation(resIdx, partnerIdx, reason);
        Map<String, Object> body = new java.util.HashMap<>();
        body.put("success", ok);
        body.put("message", ok ? "예약이 거절되었습니다." : "거절 처리에 실패했습니다. (이미 처리됐거나 권한 없음)");
        return ok ? ResponseEntity.ok(body)
                  : ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    /* ──────────────────────────────────────────────────────────
       GET /partner/reservation/revenue  (@ResponseBody)
       ────────────────────────────────────────────────────────── */
    @GetMapping("/revenue")
    @ResponseBody
    public Map<String, Object> revenue(
            @RequestParam(required = false, defaultValue = "") String startDate,
            @RequestParam(required = false, defaultValue = "") String endDate,
            @RequestParam(required = false, defaultValue = "daily") String periodType,
            HttpSession session
    ) {
        int partnerIdx = getPartnerIdx(session);
        return service.getRevenueData(partnerIdx, startDate, endDate, periodType);
    }
}
