package org.study.project05.branch.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BranchSpaceVO {

    private int    spcIdx;        // s_idx        공간 번호 (PK)
    private int    brnIdx;        // b_idx        소속 지점 번호 (FK)
    private String spcType;       // s_type       공간 종류 (OFFICE, MEETING 등)
    private String spcName;       // s_name       공간 이름
    private int    spcPrice;      // s_price      시간당 가격
    private int    spcMaxCapacity;// s_max_capacity 최대 수용 인원
    private String spcDescription;// s_description 공간 설명
    private String spcImg;        // s_img        공간 대표 이미지
    private LocalDateTime spcCreated; // s_created 등록일시

    /** 서비스 레이어에서 조립 — 공간별 편의시설 */
    private FacilityVO facilities;
}
