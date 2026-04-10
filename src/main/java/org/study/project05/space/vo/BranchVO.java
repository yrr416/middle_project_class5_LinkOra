package org.study.project05.space.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class BranchVO {

    private int    brnIdx;
    private int    ptnIdx;
    private String brnName;
    private String brnDescription;
    private String brnFile;
    private String brnAddress;
    private String brnLatitude;
    private String brnLongitude;
    private String brnPhone;
    private String brnSns;
    private String brnHours;
    private String brnNotice;
    private String brnRefundPoli;

    /** [추가] 거리 계산 결과 (단위: km) */
    private Double distance;

    /** JOIN 으로 가져오는 파트너 브랜드명 */
    private String partnerName;


    /** 서비스 레이어에서 조립 — 지점 내 예약 가능 공간 목록 */
    private List<SpaceVO> spaces;
}
