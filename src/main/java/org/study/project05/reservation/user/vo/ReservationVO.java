package org.study.project05.reservation.user.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReservationVO {

    private int    resIdx;
    private int    spcIdx;
    private int    userIdx;
    private String resStartTime;
    private String resEndTime;
    private int    resHeadcount;
    private String resTotalPrice;
    private String resStatus;

    /** 목록 조회 시 JOIN으로 가져오는 표시용 필드 */
    private String spaceName;
    private String branchName;
}
