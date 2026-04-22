package org.study.project05.reservation.user.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.project05.reservation.user.service.UserReservationService;
import org.study.project05.reservation.user.vo.UserReservationVO;
import org.study.project05.branch.service.SpaceBranchService;
import org.study.project05.member.vo.UserProfileVO;

import java.util.List;
import java.util.Map;

// 관리자용 ReservationController와 빈 이름 충돌을 피하기 위해 UserReservationController로 명명
@Controller
@RequestMapping("/reservation")
public class  UserReservationController {

    @Autowired
    private UserReservationService reservationService;
    @Autowired
    private SpaceBranchService branchService;

    /** 예약 폼 — spcIdx 기반 */
    @GetMapping("/form")
    public String form(@RequestParam int spcIdx, Model model) {
        model.addAttribute("space",  branchService.getSpaceById(spcIdx));
        model.addAttribute("branch", branchService.getBranchBySpaceIdx(spcIdx));
        return "reservation/form";
    }

    /** 예약 제출 */
    @PostMapping("/submit")
    public String submit(UserReservationVO vo,
                         HttpSession session,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        UserProfileVO loginUser = (UserProfileVO) session.getAttribute("loginUser");
        vo.setUserIdx(loginUser.getUserIdx());

        try {
            reservationService.reserve(vo);

            // ONLINE: 결제창으로 이동 / OFFLINE: 바로 예약완료
            if ("ONLINE".equals(vo.getPaymentType())) {
                session.setAttribute("pendingResIdx",     vo.getResIdx());
                session.setAttribute("pendingAmount",     Integer.parseInt(vo.getResTotalPrice()));
                session.setAttribute("pendingSpaceName",  branchService.getSpaceById(vo.getSpcIdx()).getSpcName());
                session.setAttribute("pendingStartTime",  vo.getResStartTime());
                session.setAttribute("pendingEndTime",    vo.getResEndTime());
                return "redirect:/payment/checkout";
            }

            redirectAttributes.addFlashAttribute("reservation", vo);
            redirectAttributes.addFlashAttribute("paymentType", "OFFLINE");
            return "redirect:/reservation/complete";

        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMsg", e.getMessage());
            model.addAttribute("space",  branchService.getSpaceById(vo.getSpcIdx()));
            model.addAttribute("branch", branchService.getBranchBySpaceIdx(vo.getSpcIdx()));
            return "reservation/form";
        }
    }

    /** 특정 날짜의 점유된 시간 목록 반환 (AJAX) */
    @GetMapping("/slots")
    @ResponseBody
    public List<Integer> getUnavailableSlots(@RequestParam int spaceIdx,
                                             @RequestParam String date) {
        return reservationService.getUnavailableSlots(spaceIdx, date);
    }

    /** 날짜별 시간대(0~23)별 잔여 좌석 수 반환 (AJAX) — INDIVIDUAL 타입 전용 */
    @GetMapping("/remaining")
    @ResponseBody
    public Map<Integer, Integer> getRemainingSeats(@RequestParam int spaceIdx,
                                                   @RequestParam String date,
                                                   @RequestParam int maxCapacity) {
        return reservationService.getRemainingSeats(spaceIdx, date, maxCapacity);
    }

    /** 예약 완료 페이지 */
    @GetMapping("/complete")
    public String complete() {
        return "reservation/complete";
    }

    /** 내 예약 목록 */
    @GetMapping("/mylist")
    public String myList(HttpSession session, Model model) {
        UserProfileVO loginUser = (UserProfileVO) session.getAttribute("loginUser");
        model.addAttribute("reservationList",
                reservationService.getMyReservations(loginUser.getUserIdx()));
        return "reservation/mylist";
    }

    /** 예약 취소 */
    @PostMapping("/cancel")
    public String cancel(@RequestParam int resIdx,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        UserProfileVO loginUser = (UserProfileVO) session.getAttribute("loginUser");
        reservationService.cancelReservation(resIdx, loginUser.getUserIdx(),
                loginUser.getEmail(), loginUser.getName());
        redirectAttributes.addFlashAttribute("cancelMsg", "예약이 취소되었습니다.");
        return "redirect:/reservation/mylist";
    }
}
