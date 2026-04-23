package org.study.project05.settings.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class RefundPolicyVO {
    private int    policyIdx;
    private int    hoursBefore;  // 예약 시작 몇 시간 전까지
    private int    refundRate;   // 환불 비율 (0~100)
    private String description;  // 관리자 표시용 설명
}
