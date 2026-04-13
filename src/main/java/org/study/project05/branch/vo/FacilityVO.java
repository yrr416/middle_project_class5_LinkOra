package org.study.project05.branch.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 공간(space)별 편의시설 정보 VO
 * DB 테이블: facilities
 * - Integer 타입 사용: DB에서 NULL 가능 컬럼이므로 int 대신 Integer로 안전하게 매핑
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FacilityVO {

    private int     facIdx;      // f_idx  (PK)
    private int     spcIdx;      // s_idx  (공간 FK)

    private Integer facCafe;     // f_cafe     카페
    private Integer facDesk;     // f_desk     개인 데스크
    private Integer facDelivery; // f_delivery 택배 수령
    private Integer facWater;    // f_water    식수
    private Integer facHours24;  // f_hours24  24시간 운영 (주의: fac24hours 아님)
    private Integer facKitchen;  // f_kitchen  주방
    private Integer facDisplay;  // f_display  디스플레이
    private Integer facStorage;  // f_storage  사물함
    private Integer facParking;  // f_parking  주차
    private Integer facFax;      // f_fax      팩스
    private Integer facPet;      // f_pet      반려동물
    private Integer facLounge;   // f_lounge   라운지
}
