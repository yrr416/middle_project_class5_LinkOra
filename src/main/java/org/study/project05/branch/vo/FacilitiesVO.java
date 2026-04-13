package org.study.project05.branch.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data // 만능 리모컨임.
@NoArgsConstructor // 빈 가방임.
@AllArgsConstructor // 꽉 찬 가방임.
@Builder // 조립 도구임.
public class FacilitiesVO {

    // 시설 번호표임 (f_idx).
    private int facIdx;
    // 카페 유무임 (f_cafe, 0/1).
    private int facCafe;
    // 개인 데스크 유무임 (f_desk).
    private int facDesk;
    // 택배 수령 가능 여부임 (f_delivery).
    private int facDelivery;
    // 식수 제공 유무임 (f_water).
    private int facWater;
    // 24시간 이용 가능 여부임 (f_24hours).
    private int facHours24;
    // 주방 시설 유무임 (f_kitchen).
    private int facKitchen;
    // 디스플레이 장비 유무임 (f_display).
    private int facDisplay;
    // 개인 사물함 유무임 (f_storage).
    private int facStorage;
    // 주차 가능 여부임 (f_parking).
    private int facParking;
    // 팩스 사용 가능 여부임 (f_fax).
    private int facFax;
    // 반려동물 동반 가능 여부임 (f_pet).
    private int facPet;
    // 휴게실(라운지) 유무임 (f_lounge).
    private int facLounge;
    // 어느 공간에 딸린 시설인지 알려줌 (s_idx).
    private int spcIdx;
}