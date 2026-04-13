package org.study.project05.space.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class SpaceVO {

    private int    spcIdx;
    private int    brnIdx;
    private String spcType;
    private String spcName;
    private String spcPrice;
    private String spcMaxCapacity;
    private String spcDescription;
    private String spcImg;

    private FacilityVO facilities;
}
