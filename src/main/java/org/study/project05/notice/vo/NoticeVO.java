package org.study.project05.notice.vo;

import lombok.*;

/**
 * notice 테이블 매핑 VO
 * camelCase 필드명 사용 (MyBatis map-underscore-to-camel-case 자동 매핑)
 *
 * ntcActive 값 정의:
 *   0 = 일반 공지 (비고정)
 *   1 = 고정 공지 (상단 고정)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NoticeVO {

    private String ntcIdx;        // PK
    private String admIdx;        // 작성 관리자 FK
    private String ntcTitle;      // 제목
    private String ntcContent;    // 본문 (HTML 허용)
    private String ntcActive;     // 0=일반, 1=고정
    private String ntcCreated;    // 작성일(발행일)
    private String ntcUpdated;    // 수정일

    // 검색/필터용 (DB 컬럼 아님)
    private String searchWord;    // 제목 검색어
    private String activeFilter;  // 고정 필터 (""=전체, "1"=고정)
}
