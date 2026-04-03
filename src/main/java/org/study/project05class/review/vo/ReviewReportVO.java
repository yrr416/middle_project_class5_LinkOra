package org.study.project05class.review.vo;

import lombok.*;

/**
 * review_report 테이블 매핑 VO
 *
 * 리뷰 신고 정보를 관리하는 VO
 * rr_status 값 정의:
 *   PENDING   = 신고 접수 (미처리)
 *   BLINDED   = 블라인드 처리 완료
 *   DISMISSED = 신고 반려 (문제없음)
 *
 * [필요 DDL]
 * CREATE TABLE review_report (
 *   rr_idx        INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
 *   v_idx         INT          NOT NULL COMMENT '신고 대상 리뷰 번호 (FK → review.v_idx)',
 *   u_idx         INT          NOT NULL DEFAULT 0 COMMENT '신고자 회원 번호 (FK → user.u_idx)',
 *   rr_reason     VARCHAR(500) NOT NULL COMMENT '신고 사유',
 *   rr_status     VARCHAR(20)  NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING/BLINDED/DISMISSED',
 *   rr_admin_reply TEXT        NULL COMMENT '관리자 처리 결과 메시지 (신고자에게 알림)',
 *   rr_created    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '신고 일시'
 * ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReviewReportVO {

    private String rr_idx;          // 신고 고유번호 (PK)
    private String v_idx;           // 신고 대상 리뷰 번호 (FK)
    private String u_idx;           // 신고자 회원 번호 (FK)
    private String u_name;          // 신고자명 (JOIN)
    private String rr_reason;       // 신고 사유
    private String rr_status;       // 처리 상태 (PENDING / BLINDED / DISMISSED)
    private String rr_admin_reply;  // 관리자 처리 결과 알림 메시지
    private String rr_created;      // 신고 일시

    // 신고된 리뷰 정보 (JOIN)
    private String v_content;       // 원본 리뷰 내용
    private String v_rating;        // 원본 리뷰 별점
    private String v_active;        // 원본 리뷰 상태
    private String s_name;          // 공간명
    private String writer_name;     // 리뷰 작성자명
}
