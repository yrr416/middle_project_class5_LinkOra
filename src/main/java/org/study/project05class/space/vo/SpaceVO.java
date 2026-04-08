package org.study.project05class.space.vo;

import lombok.*;

/**
 * 공간(space) 테이블과 매핑되는 Value Object
 * camelCase 필드명 사용 (MyBatis map-underscore-to-camel-case 자동 매핑)
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SpaceVO {

    private String spcIdx;           // 공간 고유번호 (PK)
    private String brnIdx;           // 지점 번호 (FK → branch)
    private String brnName;          // 지점명 (JOIN)
    private String spcName;          // 공간명
    private String spcType;          // 타입 (INDIVIDUAL / GROUP)
    private String spcPrice;         // 시간당 가격
    private String spcMaxCapacity;   // 최대 수용 인원
    private String spcDescription;   // 공간 설명
    private String spcImg;           // 대표 이미지 경로
    private String spcActive;        // 상태 (0=대기, 1=활성, 2=비활성)
    private String spcCreated;       // 등록일시

    // 통계용 (서브쿼리)
    private String reservationCnt;   // 총 예약 횟수
    private String usageRate;        // 이용률(%)

    // 검색/필터용 (DB 컬럼 아님)
    private String typeFilter;       // 타입 필터
    private String activeFilter;     // 활성 상태 필터
    private String searchWord;       // 검색어
}
