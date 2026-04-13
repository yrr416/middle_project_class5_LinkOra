package org.study.project05.reservation.user.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.project05.member.vo.UserProfileVO;
import org.study.project05.reservation.user.service.PaymentService;

import java.util.UUID;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Value("${toss.client-key}")
    private String clientKey;

    @Autowired
    private PaymentService paymentService;

    /**
     * 결제 페이지
     *
     * UserReservationController.submit() 에서 예약 저장(PENDING) 후 여기로 redirect됨
     * 세션에서 resIdx와 금액을 꺼내 토스 결제창을 띄울 준비를 함
     */
    @GetMapping("/checkout")
    public String checkout(HttpSession session, Model model) {
        // 예약 제출 시 세션에 저장해둔 값 꺼내기
        Integer resIdx  = (Integer) session.getAttribute("pendingResIdx");
        Integer amount  = (Integer) session.getAttribute("pendingAmount");
        String spaceName = (String) session.getAttribute("pendingSpaceName");

        if (resIdx == null || amount == null) {
            // 세션 만료 또는 비정상 접근
            return "redirect:/";
        }

        // 주문번호: 매 결제마다 고유해야 함 → UUID 사용
        // 앞 8자리만 사용해 가독성 확보 (충분히 고유함)
        String orderId = "ORDER-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // 결제 완료 후 세션에서 orderId도 필요하므로 저장
        session.setAttribute("pendingOrderId", orderId);

        model.addAttribute("clientKey",  clientKey);
        model.addAttribute("orderId",    orderId);
        model.addAttribute("amount",     amount);
        model.addAttribute("spaceName",  spaceName);
        model.addAttribute("resIdx",     resIdx);

        return "reservation/checkout";
    }

    /**
     * 결제 성공 콜백
     *
     * 토스페이먼츠가 결제 완료 후 이 URL로 redirect해줌
     * paymentKey, orderId, amount 는 토스가 쿼리파라미터로 넘겨줌
     */
    @GetMapping("/success")
    public String success(@RequestParam String paymentKey,
                          @RequestParam String orderId,
                          @RequestParam int    amount,
                          HttpSession session,
                          RedirectAttributes redirectAttributes) {

        UserProfileVO loginUser = (UserProfileVO) session.getAttribute("loginUser");
        Integer resIdx = (Integer) session.getAttribute("pendingResIdx");

        try {
            // 핵심: 락 확인 → 토스 승인 API → DB 업데이트 → 메일 발송
            paymentService.confirmPayment(
                    paymentKey, orderId, amount,
                    resIdx, loginUser.getUserIdx(),
                    loginUser.getEmail(),   // 메일 수신 주소
                    loginUser.getName(),    // 수신자 이름
                    (String) session.getAttribute("pendingSpaceName")  // 공간명
            );

            // 성공 후 세션 정리
            session.removeAttribute("pendingResIdx");
            session.removeAttribute("pendingAmount");
            session.removeAttribute("pendingSpaceName");
            session.removeAttribute("pendingOrderId");

            return "redirect:/reservation/complete";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/payment/fail";
        }
    }

    /**
     * 결제 실패/취소 페이지
     *
     * 사용자가 결제창을 닫거나 카드 오류 등으로 실패했을 때
     * 예약은 PENDING 상태로 남고, 스케줄러가 나중에 CANCELLED 처리함
     */
    @GetMapping("/fail")
    public String fail(Model model,
                       @RequestParam(required = false) String message,
                       HttpSession session) {
        // 토스가 실패 시 넘겨주는 메시지 또는 우리 서버 예외 메시지
        String errorMsg = message != null ? message :
                (String) session.getAttribute("errorMsg");
        model.addAttribute("errorMsg", errorMsg);
        return "reservation/payFail";
    }
}
