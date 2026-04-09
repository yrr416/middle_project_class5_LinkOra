package org.study.project05.reservation.vo;

import lombok.Data;

/**
 * 예약(reservation) 테이블 매핑 VO
 * camelCase 필드명 사용 (MyBatis map-underscore-to-camel-case 자동 매핑)
 */
@Data
public class ReservationVO {

    /* reservation 컬럼 */
    private int    resIdx;         // 예약 고유번호 (PK)
    private int    spcIdx;         // 공간 번호 (FK → space)
    private int    userIdx;        // 회원 번호 (FK → user)
    private String resStartTime;   // 예약 시작 일시
    private String resEndTime;     // 예약 종료 일시
    private String resContent;     // 취소 시 취소 사유 저장
    private int    resHeadcount;   // 예약 인원
    private int    resTotalPrice;  // 총 결제 금액
    private String resCreated;     // 예약 생성일
    private String resUpdated;     // 예약 수정일
    private String resStatus;      // PENDING/CONFIRMED/USING/COMPLETED/CANCELLED

    /* user JOIN */
    private String userName;       // 고객 이름
    private String userEmail;      // 고객 이메일
    private String userPhone;      // 고객 전화번호

    /* space JOIN */
    private String spcName;        // 공간명
    private String spcType;        // 공간 타입
    private int    spcPrice;       // 시간당 가격

    /* branch JOIN */
    private String brnName;        // 지점명

    /* 검색·필터 파라미터 */
    private String startDate;      // 검색 시작일
    private String endDate;        // 검색 종료일
    private String statusFilter;   // 상태 필터
    private String spaceFilter;    // 공간 필터
    private String searchWord;     // 검색어
}
