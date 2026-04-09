package org.study.project05.settings.vo;

import lombok.*;

/**
 * admin_log 테이블 매핑 VO
 * 관리자 활동 이력
 * camelCase 필드명 사용 (MyBatis map-underscore-to-camel-case 자동 매핑)
 */
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class AdminLogVO {
    private String alogIdx;     // PK
    private String admIdx;      // 관리자 번호 (FK → admin)
    private String admName;     // 관리자 이름 (JOIN)
    private String alogAction;  // 수행 작업
    private String alogDetail;  // 상세 내용
    private String alogIp;      // 접속 IP
    private String alogCreated; // 작업 일시
}
