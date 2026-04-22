package org.study.project05.reservation.user.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class PaymentVO {

    private int    payIdx;      // payment 테이블 PK
    private int    resIdx;      // 예약 FK (reservation.r_idx)
    private int    userIdx;     // 회원 FK
    private String paymentKey;  // 토스가 발급하는 고유 결제 키
    private String orderId;     // 우리가 만든 주문번호 (UUID)
    private int    amount;      // 결제 금액
    private String payStatus;    // DONE / CANCELED
    private String paidAt;       // 결제 시각
    private int    refundAmount; // 환불 금액
}
