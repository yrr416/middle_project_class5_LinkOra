package org.study.midproject.inquiry.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * InquiryVO - 자바 표준 필드명 버전
 * JSP EL(PropertyNotFoundException) 문제를 100% 방지하기 위해 
 * i_title -> title, u_idx -> userIdx 등 표준 Camel Case를 사용합니다.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class InquiryVO {

    private Integer idx;         // i_idx
    private Long userIdx;        // u_idx
    private String category;     // i_category
    private String title;        // i_title
    private String content;      // i_content
    private String fileUrl;      // i_file_url
    private String status;       // i_status
    private String answer;       // i_answer
    private String created;      // i_created
    private String answered;     // i_answered

}
