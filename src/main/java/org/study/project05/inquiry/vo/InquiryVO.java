package org.study.project05.inquiry.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
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
@Builder
public class InquiryVO {

    private Integer iidx;       // i_idx
    private Long uidx;          // u_idx
    private String icategory;   // i_category
    private String ititle;      // i_title
    private String icontent;    // i_content
    private String ifileurl;    // i_file_url
    private String istatus;     // i_status
    private String ianswer;     // i_answer
    private String icreated;    // i_created
    private String ianswered;   // i_answered

}
