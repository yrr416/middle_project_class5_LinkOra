package org.study.project05.inquiry.vo;

import org.apache.ibatis.type.Alias;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * InquiryVO - 자바 표준 필드명 버전
 * JSP EL(PropertyNotFoundException) 문제를 100% 방지하기 위해 
 * inq_title -> inqTitle, u_idx -> userIdx 등 표준 Camel Case를 사용합니다.
 */
@Alias("InquiryVO")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class InquiryVO {

    private Integer inqIdx;       // i_idx
    private int userIdx;          // u_idx
    private String inqCategory;   // i_category
    private String inqTitle;      // i_title
    private String inqContent;    // i_content
    private String inqFileUrl;    // i_file_url
    private String inqStatus;     // i_status (PENDING / COMPLETE)
    private String inqAnswer;     // i_answer
    private String inqCreated;    // i_created
    private String inqAnswered;   // i_answered
    private int inqActive;        // 1:활성, 0:삭제

    // 관리자 목록 조회 시 JOIN으로 가져오는 작성자 이름
    private String userName;

    // 관리자 목록 검색/필터 파라미터 (DB 컬럼 아님)
    private String statusFilter;
    private String searchWord;
}
