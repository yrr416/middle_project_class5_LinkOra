package org.study.project05.reservation.user.service;

public interface PaymentService {

    /**
     * 토스페이먼츠 최종 승인 처리 + 예약 확인 메일 발송
     *
     * @param paymentKey 토스가 발급한 결제 고유 키
     * @param orderId    우리가 만든 주문번호 (UUID)
     * @param amount     결제 금액
     * @param resIdx     연결된 예약 번호
     * @param userIdx    회원 번호
     * @param email      결제자 이메일 (메일 발송용)
     * @param name       결제자 이름 (메일 발송용)
     * @param spaceName  예약 공간명 (메일 발송용)
     */
    void confirmPayment(String paymentKey, String orderId, int amount,
                        int resIdx, int userIdx,
                        String email, String name, String spaceName);
}
