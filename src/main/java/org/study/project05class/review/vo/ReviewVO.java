package org.study.project05class.review.vo;

import lombok.*;

/**
 * review 테이블 매핑 VO
 *
 * v_active 값 정의:
 *   0 = 일반 (미처리, 관리자 확인 필요)
 *   1 = 처리완료 (관리자 답글 → 관리자 페이지 숨김)
 *   2 = 블라인드 처리
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReviewVO {

    private String v_idx;           // PK
    private String u_idx;           // 작성자 FK
    private String u_name;          // 작성자명 (JOIN)
    private String s_idx;           // 공간 FK
    private String s_name;          // 공간명 (JOIN)
    private String v_time;          // 이용 시간
    private String v_rating;        // 별점 (1~5)
    private String v_content;       // 리뷰 내용
    private String v_parent_idx;    // 0=원본 리뷰, 양수=답글 (부모 v_idx)
    private String v_created_at;    // 작성일
    private String v_updated_at;    // 수정일
    private String v_active;        // 0=일반, 1=처리완료(숨김), 2=블라인드
    private String v_img;           // 첨부 이미지

    // 통계/조인용 (DB 컬럼 아님)
    private String report_cnt;      // 신고 횟수
    private String admin_reply;     // 관리자 답글 내용 (조회용)
    private String admin_reply_at;  // 관리자 답글 작성일

    // 검색/필터용
    private String rating_filter;   // 별점 필터
    private String blind_filter;    // 블라인드 필터 (""=전체, "0"=정상, "2"=블라인드)
    private String search_word;     // 검색어 (작성자 or 내용)
    private String sort_reported;   // "1" = 신고된 리뷰 우선
}
