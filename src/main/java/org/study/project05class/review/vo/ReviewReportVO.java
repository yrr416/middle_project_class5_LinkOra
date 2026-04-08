package org.study.project05class.review.vo;

import lombok.*;

/**
 * review_report 테이블 매핑 VO
 * camelCase 필드명 사용 (MyBatis map-underscore-to-camel-case 자동 매핑)
 *
 * rvrStatus 값 정의:
 *   PENDING   = 신고 접수 (미처리)
 *   BLINDED   = 블라인드 처리 완료
 *   DISMISSED = 신고 반려 (문제없음)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReviewReportVO {

    private String rvrIdx;          // 신고 고유번호 (PK)
    private String revIdx;          // 신고 대상 리뷰 번호 (FK)
    private String userIdx;         // 신고자 회원 번호 (FK)
    private String userName;        // 신고자명 (JOIN)
    private String rvrReason;       // 신고 사유
    private String rvrStatus;       // 처리 상태 (PENDING / BLINDED / DISMISSED)
    private String rvrAdminReply;   // 관리자 처리 결과 알림 메시지
    private String rvrCreated;      // 신고 일시

    // 신고된 리뷰 정보 (JOIN)
    private String revContent;      // 원본 리뷰 내용
    private String revRating;       // 원본 리뷰 별점
    private String revActive;       // 원본 리뷰 상태
    private String spcName;         // 공간명
    private String writerName;      // 리뷰 작성자명
}
