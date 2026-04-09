package org.study.project05.inquiry.vo;

import lombok.*;

/**
 * inquiries 테이블 매핑 VO
 * camelCase 필드명 사용 (MyBatis map-underscore-to-camel-case 자동 매핑)
 *
 * inqStatus 값 정의:
 *   PENDING  = 미답변 (기본값, 고객이 문의 등록 시)
 *   COMPLETE = 답변완료 (관리자가 답변 저장 시 자동 변경)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class InquiryVO {

    private String inqIdx;        // PK
    private String userIdx;       // 작성 고객 FK
    private String userName;      // 작성자명 (user 테이블 JOIN)
    private String inqCategory;   // 문의 유형
    private String inqTitle;      // 제목
    private String inqStatus;     // PENDING / COMPLETE
    private String inqContent;    // 문의 내용
    private String inqFileUrl;    // 첨부 파일 URL
    private String inqAnswer;     // 관리자 답변 내용
    private String inqCreated;    // 문의 작성일
    private String inqAnswered;   // 답변 일시

    // 검색/필터용 (DB 컬럼 아님)
    private String statusFilter;  // ""=전체, "PENDING"=미답변, "COMPLETE"=완료
    private String searchWord;    // 제목/작성자 검색어
}
