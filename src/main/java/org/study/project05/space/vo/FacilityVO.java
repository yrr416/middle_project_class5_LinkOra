package org.study.project05.space.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class FacilityVO {

    private int     facIdx;
    private int     spcIdx;
    private Integer facCafe;
    private Integer facDesk;
    private Integer facDelivery;
    private Integer facWater;
    private Integer facHours24;   // DB 컬럼: f_24hours (숫자 시작 불가 → alias)
    private Integer facKitchen;
    private Integer facDisplay;
    private Integer facStorage;
    private Integer facParking;
    private Integer facFax;
    private Integer facPet;
    private Integer facLounge;
}
