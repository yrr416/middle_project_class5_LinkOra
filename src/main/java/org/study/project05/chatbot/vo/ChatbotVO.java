package org.study.project05.chatbot.vo;

import lombok.*;

/**
 * 챗봇 상담내역 VO
 * chatbot 테이블 + user 테이블 JOIN 결과를 담는 클래스
 * camelCase 필드명 사용 (MyBatis map-underscore-to-camel-case 자동 매핑)
 */
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class ChatbotVO {

    // ── 개별 메시지 필드 (chatbot 테이블) ──────────────────────────
    private int    chatIdx;        // 메시지 고유번호 (PK)
    private int    userIdx;        // 작성 회원 번호 (FK → user)
    private int    chatSession;    // 대화 세션 번호
    private String chatMessage;    // 고객 질문 내용
    private String chatResponse;   // AI 답변 내용
    private String chatIntent;     // 질문 의도
    private String chatPage;       // 질문이 발생한 페이지 경로
    private String chatTime;       // 대화 발생 날짜

    // ── user 테이블 JOIN 필드 ──────────────────────────────────────
    private String userName;       // 고객 이름
    private String userEmail;      // 고객 이메일
    private String userRole;       // 고객 역할
    private String userCreated;    // 고객 가입일

    // ── 세션 요약 필드 (목록 페이지용, GROUP BY 집계 결과) ──────────
    private String firstMessage;    // 세션의 첫 번째 질문 미리보기
    private int    msgCount;        // 세션 내 총 대화 수
    private String startTime;       // 상담 시작일
    private String endTime;         // 상담 종료일
    private int    unresolvedCount; // 미해결 메시지 수

    // ── 검색·필터 파라미터 (DB 컬럼 아님) ─────────────────────────
    private String searchWord;    // 고객명 또는 이메일 검색어
    private String statusFilter;  // 상태 필터: ""=전체, "완료", "미해결"
    private String dateFrom;      // 조회 시작 날짜
    private String dateTo;        // 조회 종료 날짜
}
