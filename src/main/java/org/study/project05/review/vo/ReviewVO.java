package org.study.project05.review.vo;

import lombok.*;

/**
 * review 테이블 매핑 VO
 * camelCase 필드명 사용 (MyBatis map-underscore-to-camel-case 자동 매핑)
 *
 * revActive 값 정의:
 *   0 = 일반 (미처리, 관리자 확인 필요)
 *   1 = 처리완료 (관리자 답글 → 관리자 페이지 숨김)
 *   2 = 블라인드 처리
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReviewVO {

    private String revIdx;           // PK
    private String userIdx;          // 작성자 FK
    private String userName;         // 작성자명 (JOIN)
    private String spcIdx;           // 공간 FK
    private String spcName;          // 공간명 (JOIN)
    private String revTime;          // 이용 시간
    private String revRating;        // 별점 (1~5)
    private String revContent;       // 리뷰 내용
    private String revParentIdx;     // 0=원본 리뷰, 양수=답글 (부모 revIdx)
    private String revCreatedAt;     // 작성일
    private String revUpdatedAt;     // 수정일
    private String revActive;        // 0=일반, 1=처리완료(숨김), 2=블라인드
    private String revImg;           // 첨부 이미지

    // 통계/조인용 (DB 컬럼 아님)
    private String reportCnt;        // 신고 횟수
    private String adminReply;       // 관리자 답글 내용 (조회용)
    private String adminReplyAt;     // 관리자 답글 작성일

    // 검색/필터용
    private String ratingFilter;     // 별점 필터
    private String blindFilter;      // 블라인드 필터 (""=전체, "0"=정상, "2"=블라인드)
    private String answerFilter;     // 답변 필터 (""=전체, "Y"=답변완료, "N"=미답변)
    private String searchWord;       // 검색어 (작성자 or 내용)
    private String sortReported;     // "1" = 신고된 리뷰 우선
}
