package org.study.project05.review.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ReviewVO {

    private int     revIdx;
    private int     spcIdx;
    private int     userIdx;
    private Integer revParentIdx;   // NULL = 최상위 후기, 값 = 답글
    private String  revContent;
    private Integer revRating;      // 1~5, 최상위 후기만 (답글은 NULL)
    private String  authorName;     // JOIN으로 가져오는 작성자 이름
    private String  spaceName;
    private Date    revCreatedAt;    // DB의 v_created_at (포맷은 JSP/JS에서 처리)

    /** 신고 누적 수 — 조회 시 서브쿼리로 계산 (신고 3회 이상이면 블라인드 처리) */
    private int reportCount;

    /** 서비스 레이어에서 조립 — 이 후기에 달린 답글 목록 */
    private List<ReviewVO> replies;
}
