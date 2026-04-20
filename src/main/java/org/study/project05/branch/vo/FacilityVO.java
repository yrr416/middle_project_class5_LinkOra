package org.study.project05.branch.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 공간(space)별 편의시설 정보 VO
 * DB 테이블: facilities
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FacilityVO {

    private int     facIdx;      // f_idx (PK)
    private int     spcIdx;      // s_idx (공간 FK)

    private Integer facCafe;     // f_cafe 카페테리아
    private Integer facDesk;     // f_desk 개인 데스크
    private Integer facDelivery; // f_delivery 택배 수령
    private Integer facWater;    // f_water 정수기/식수
    private Integer facHours24;  // f_hours24 24시간 운영
    private Integer facKitchen;  // f_kitchen 공용 주방
    private Integer facDisplay;  // f_display TV/프로젝터
    private Integer facStorage;  // f_storage 창고/사물함
    private Integer facParking;  // f_parking 주차 시설
    private Integer facFax;      // f_fax 팩스 기기
    private Integer facPet;      // f_pet 반려동물 동반
    private Integer facLounge;   // f_lounge 휴식 라운지

    // 추가 항목
    private Integer facWifi;     // f_wifi 와이파이
    private Integer facCoffee;   // f_coffee 무료 커피/간식
    private Integer facPrinter;  // f_printer 프린터/복사기
}