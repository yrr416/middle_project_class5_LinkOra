package org.study.project05class.space.vo;

import lombok.*;

/**
 * 공간(space) 테이블과 매핑되는 Value Object
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SpaceVO {

    private String s_idx;           // 공간 고유번호 (PK)
    private String b_idx;           // 지점 번호 (FK → branch)
    private String b_name;          // 지점명 (JOIN)
    private String s_name;          // 공간명
    private String s_type;          // 타입 (CONFERENCE / INDIVIDUAL / LOUNGE)
    private String s_price;         // 시간당 가격
    private String s_max_capacity;  // 최대 수용 인원
    private String s_description;   // 공간 설명
    private String s_img;           // 대표 이미지 경로
    private String s_active;        // 상태 (0=대기, 1=활성, 2=비활성)
    private String s_created;       // 등록일시

    // 통계용 (JOIN 또는 서브쿼리)
    private String reservation_cnt; // 총 예약 횟수
    private String usage_rate;      // 이용률(%)

    // 검색/필터용 (DB 컬럼 아님)
    private String type_filter;     // 타입 필터
    private String active_filter;   // 활성 상태 필터
    private String search_word;     // 검색어
}
