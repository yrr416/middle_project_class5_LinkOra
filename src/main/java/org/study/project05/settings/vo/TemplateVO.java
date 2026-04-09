package org.study.project05.settings.vo;

import lombok.*;

/**
 * inquiry_template 테이블 매핑 VO
 * 문의 답변 자주 쓰는 템플릿
 * camelCase 필드명 사용 (MyBatis map-underscore-to-camel-case 자동 매핑)
 */
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class TemplateVO {
    private String tplIdx;      // PK
    private String tplTitle;    // 템플릿 제목
    private String tplContent;  // 템플릿 내용
    private String tplCreated;  // 등록일
}
