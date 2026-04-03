package org.study.project05class.inquiry.vo;

import lombok.*;

/**
 * inquiries 테이블 매핑 VO
 *
 * i_status 값 정의:
 *   PENDING  = 미답변 (기본값, 고객이 문의 등록 시)
 *   COMPLETE = 답변완료 (관리자가 답변 저장 시 자동 변경)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class InquiryVO {

    private String i_idx;        // PK
    private String u_idx;        // 작성 고객 FK
    private String u_name;       // 작성자명 (user 테이블 JOIN)
    private String i_category;   // 문의 유형
    private String i_title;      // 제목
    private String i_status;     // PENDING / COMPLETE
    private String i_content;    // 문의 내용
    private String i_file_url;   // 첨부 파일 URL
    private String i_answer;     // 관리자 답변 내용
    private String i_created;    // 문의 작성일
    private String i_answered;   // 답변 일시

    // 검색/필터용 (DB 컬럼 아님)
    private String status_filter; // ""=전체, "PENDING"=미답변, "COMPLETE"=완료
    private String search_word;   // 제목/작성자 검색어
}
