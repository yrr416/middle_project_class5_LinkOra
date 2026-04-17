package org.study.project05.chatbot.service;

import org.study.project05.chatbot.vo.ChatbotVO;

import java.util.List;

/**
 * 챗봇 상담내역 서비스 인터페이스
 * 목록 조회, 세션 요약, 메시지 목록 등 비즈니스 로직 정의
 */
public interface ChatbotService {

    /**
     * 검색·필터 조건에 맞는 전체 세션 수 반환 (페이징 계산용)
     * @param chatbotVO 검색어(search_word), 상태(status_filter), 날짜 범위(date_from~date_to)
     */
    int getSessionCount(ChatbotVO chatbotVO);

    /**
     * 세션 목록 조회 (페이징 + 검색/필터)
     * @param numPerPage 페이지당 표시 건수 (10 / 20 / 50)
     * @param offset     조회 시작 위치 (= (nowPage - 1) * numPerPage)
     * @param chatbotVO  검색·필터 파라미터
     */
    List<ChatbotVO> getSessionList(int numPerPage, int offset, ChatbotVO chatbotVO);

    /**
     * 세션 요약 정보 조회 (상세 페이지 상단 고객 정보·상담 메타 표시용)
     * @param c_session 조회할 세션 번호
     */
    ChatbotVO getSessionSummary(int c_session);

    /**
     * 세션 내 전체 메시지 목록 조회 (말풍선 UI 대화 내역 표시용)
     * @param c_session 조회할 세션 번호
     */
    List<ChatbotVO> getMessageList(int c_session);
}
