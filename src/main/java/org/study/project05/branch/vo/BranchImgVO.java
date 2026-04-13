package org.study.project05.branch.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 지점 이미지 VO
 * DB 테이블: branch_img
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class BranchImgVO {
    private int    biIdx;    // bi_idx    이미지 번호 (PK)
    private int    bIdx;     // b_idx     지점 번호 (FK)
    private String biUrl;    // bi_url    이미지 URL
    private int    biOrder;  // bi_order  정렬 순서
    private int    biIsMain; // bi_is_main 대표 이미지 여부 (1=대표)
}
