package org.study.project05class.notice.vo;

import lombok.*;

/**
 * notice 테이블 매핑 VO
 *
 * n_active 값 정의:
 *   0 = 일반 공지 (비고정)
 *   1 = 고정 공지 (상단 고정)
 *
 * 발행 방식:
 *   즉시 발행 → n_created = NOW()
 *   예약 발행 → n_created = 설정한 미래 날짜
 *   (n_created <= NOW() 인 공지만 사용자에게 노출)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NoticeVO {

    private String n_idx;        // PK
    private String a_idx;        // 작성 관리자 FK
    private String n_title;      // 제목
    private String n_content;    // 본문 (HTML 허용)
    private String n_active;     // 0=일반, 1=고정
    private String n_created;    // 작성일(발행일)
    private String n_updated;    // 수정일

    // 검색/필터용 (DB 컬럼 아님)
    private String search_word;  // 제목 검색어
    private String active_filter;// 고정 필터 (""=전체, "1"=고정)
}
