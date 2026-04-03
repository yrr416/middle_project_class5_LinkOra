package org.study.project05class.settings.vo;

import lombok.*;

/**
 * inquiry_template 테이블 매핑 VO
 * 문의 답변 자주 쓰는 템플릿
 */
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class TemplateVO {
    private String t_idx;      // PK
    private String t_title;    // 템플릿 제목
    private String t_content;  // 템플릿 내용
    private String t_created;  // 등록일
}
