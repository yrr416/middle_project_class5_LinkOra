package org.study.project05.partner.vo;

import lombok.*;

// 파트너 지점(지사) 등록 VO
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class BranchRegVO {
    private int    brnIdx;          // 지점 PK (저장 후 세팅)
    private int    ptnIdx;          // 파트너 PK
    private String brnName;         // 지점명
    private String brnDescription;  // 지점 설명
    private String brnAddress;      // 전체 주소
    private String brnPhone;        // 연락처
    private String brnSns;          // SNS URL
    private String brnHours;        // 운영시간 문자열
    private int    brnActive;       // 활성 여부
    private String brnUrl;          // 대표 이미지 URL

    // 운영 정보 (Step2)
    private String operDays;        // 운영 요일 (예: "월,화,수,목,금")
    private String operStart;       // 운영 시작 시간 (예: "09:00")
    private String operEnd;         // 운영 종료 시간 (예: "18:00")
    private int     holidayOp;      // 공휴일 운영 여부 (1=운영, 0=미운영)
    private String minUnit;         // 최소 예약 단위 (예: "1시간")
    private int    maxDays;         // 최대 예약 가능 일수

    // 주소 분리 필드
    private String roadAddress;     // 도로명 주소
    private String detailAddress;   // 상세 주소

    // 관리 페이지용 (DB 저장 안 함)
    private int spaceCount;                     // 소속 공간 수
    private int currentHeadcount;               // 현재 이용중 총 인원
    private java.util.List<SpaceRegVO> spaces;  // 소속 공간 목록
}
