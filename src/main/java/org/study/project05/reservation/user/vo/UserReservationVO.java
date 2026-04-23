package org.study.project05.reservation.user.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserReservationVO {

    private Integer resIdx;
    private Integer spcIdx;
    private Integer userIdx;
    private String  resStartTime;
    private String  resEndTime;
    private Integer resHeadcount;
    private String resTotalPrice;
    private String resStatus;
    private String paymentType;  // ONLINE: 웹결제, OFFLINE: 현장결제

    /** 목록 조회 시 JOIN으로 가져오는 표시용 필드 */
    private String spaceName;
    private String branchName;
}
