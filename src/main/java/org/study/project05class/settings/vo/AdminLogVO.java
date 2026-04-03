package org.study.project05class.settings.vo;

import lombok.*;

/**
 * admin_log 테이블 매핑 VO
 * 관리자 활동 이력
 */
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class AdminLogVO {
    private String l_idx;     // PK
    private String a_idx;     // 관리자 번호
    private String a_name;    // 관리자 이름
    private String l_action;  // 수행 작업
    private String l_detail;  // 상세 내용
    private String l_ip;      // 접속 IP
    private String l_created; // 작업 일시
}
