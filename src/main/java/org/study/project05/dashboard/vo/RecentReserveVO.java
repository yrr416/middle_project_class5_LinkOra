package org.study.project05.dashboard.vo;

import lombok.Data;

/**
 * 대시보드 최근 예약 목록 VO
 * camelCase 필드명 사용 (MyBatis map-underscore-to-camel-case 자동 매핑)
 */
@Data
public class RecentReserveVO {
    private String resIdx;     // 예약 고유번호
    private String userName;   // 고객 이름
    private String spcName;    // 공간명
    private String resDate;    // 예약 날짜
    private String resStatus;  // 예약 상태
    private String resPrice;   // 예약 금액
}
