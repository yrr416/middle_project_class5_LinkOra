package org.study.project05.partner.vo;

import lombok.*;

// 파트너 공간(스페이스) 등록 VO
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class SpaceRegVO {
    private int    spcIdx;          // 공간 PK (저장 후 세팅)
    private int    brnIdx;          // 지점 PK (FK)
    private String spcType;         // 공간 유형: INDIVIDUAL / GROUP
    private String spcName;         // 공간 이름
    private int    spcPrice;        // 시간당 가격
    private int    spcMaxCapacity;  // 최대 수용 인원
    private String spcDescription;  // 공간 설명
    private String spcImg;          // 대표 이미지 URL
    private int    spcActive;       // 활성 여부

    // 시설 정보 (Step3)
    private int facCafe;      // 카페
    private int facDesk;      // 좌석
    private int facDelivery;  // 배달 수령
    private int facWater;     // 음료 제공
    private int fac24hours;   // 24시간 운영
    private int facKitchen;   // 주방
    private int facDisplay;   // 디스플레이
    private int facStorage;   // 짐보관
    private int facParking;   // 주차
    private int facFax;       // 팩스
    private int facPet;       // 반려동물
    private int facLounge;    // 라운지
}
