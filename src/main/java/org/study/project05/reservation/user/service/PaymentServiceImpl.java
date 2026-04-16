package org.study.project05.reservation.user.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.study.project05.reservation.user.mapper.PaymentMapper;
import org.study.project05.reservation.user.mapper.UserReservationMapper;
import org.study.project05.reservation.user.vo.PaymentVO;
import org.study.project05.reservation.user.vo.ReservationVO;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

@Service
public class PaymentServiceImpl implements PaymentService {

    private static final String TOSS_CONFIRM_URL = "https://api.tosspayments.com/v1/payments/confirm";

    @Value("${toss.secret-key}")
    private String secretKey;

    @Autowired
    private UserReservationMapper reservationMapper;

    @Autowired
    private PaymentMapper paymentMapper;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private ReservationMailService mailService;

    /**
     * 결제 최종 승인 처리
     *
     * 흐름:
     * 1. 예약 행에 락(SELECT FOR UPDATE)을 건다
     * 2. 아직 PENDING 상태인지 확인 → 만료됐으면 예외 발생
     * 3. 토스 승인 API 호출 → 실제 결제 발생
     * 4. 예약 상태를 CONFIRMED로 변경
     * 5. payment 테이블에 결제 이력 저장
     * 6. 예약 확인 메일 발송 (실패해도 결제는 유지)
     */
    @Override
    @Transactional
    public void confirmPayment(String paymentKey, String orderId, int amount,
                               int resIdx, int userIdx,
                               String email, String name, String spaceName) {

        // 1. 행 락을 걸고 현재 예약 상태 + 시간 정보 조회
        ReservationVO reservation = reservationMapper.selectByIdForUpdate(resIdx);

        // 2. PENDING이 아니면(= 이미 만료/취소됨) 결제 진행 중단
        //    이 시점에서 토스 승인 API를 부르지 않으므로 실제 결제도 발생하지 않음
        if (!"PENDING".equals(reservation.getResStatus())) {
            throw new IllegalStateException("만료된 예약입니다. 결제가 진행되지 않았습니다.");
        }

        // 3. 토스페이먼츠 최종 승인 API 호출 → 실제로 카드에서 돈이 빠져나감
        callTossConfirmApi(paymentKey, orderId, amount);

        // 4. 예약 상태 PENDING → CONFIRMED
        reservationMapper.updateStatus(resIdx, "CONFIRMED");

        // 5. 결제 이력 저장
        PaymentVO paymentVO = new PaymentVO();
        paymentVO.setResIdx(resIdx);
        paymentVO.setUserIdx(userIdx);
        paymentVO.setPaymentKey(paymentKey);
        paymentVO.setOrderId(orderId);
        paymentVO.setAmount(amount);
        paymentVO.setPayStatus("DONE");
        paymentMapper.insertPayment(paymentVO);

        // 6. 예약 확인 메일 발송
        //    메일 발송은 트랜잭션 외부 처리 — 실패해도 결제/예약은 이미 커밋됨
        mailService.sendReservationConfirm(
                email, name, spaceName,
                reservation.getResStartTime(),
                reservation.getResEndTime(),
                amount
        );
    }

    /**
     * 토스페이먼츠 승인 API 호출 (Basic Auth)
     * secretKey 뒤에 콜론(:)을 붙여 Base64 인코딩 → Authorization 헤더에 포함
     */
    private void callTossConfirmApi(String paymentKey, String orderId, int amount) {
        String encoded = Base64.getEncoder()
                .encodeToString((secretKey + ":").getBytes());

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Basic " + encoded);

        Map<String, Object> body = new HashMap<>();
        body.put("paymentKey", paymentKey);
        body.put("orderId",    orderId);
        body.put("amount",     amount);

        restTemplate.postForEntity(TOSS_CONFIRM_URL,
                new HttpEntity<>(body, headers), String.class);
    }
}
