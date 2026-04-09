package org.study.project05.chatbot.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.chatbot.vo.ChatbotVO;

import java.util.List;
import java.util.Map;

/**
 * 챗봇 상담내역 MyBatis Mapper 인터페이스
 * ChatbotMapper.xml 과 매핑되어 DB 쿼리를 실행한다
 */
@Mapper
public interface ChatbotMapper {

    /**
     * 조건에 맞는 전체 세션 수 조회 (페이징 계산용)
     * - map 키: chatbotVO(검색·필터 조건), numPerPage, offset
     */
    int getSessionCount(Map<String, Object> map);

    /**
     * 세션 목록 조회 (페이징 + 검색/필터 적용)
     * - 각 세션의 첫 질문·대화 수·상담일·미해결 수를 함께 반환
     * - map 키: chatbotVO(검색·필터 조건), numPerPage, offset
     */
    List<ChatbotVO> getSessionList(Map<String, Object> map);

    /**
     * 특정 세션의 요약 정보 조회 (상세 페이지 상단 패널용)
     * - 고객 정보, 상담 시작/종료일, 총 대화 수, 미해결 수 포함
     * @param c_session 조회할 세션 번호
     */
    ChatbotVO getSessionSummary(@Param("chatSession") int chatSession);

    /**
     * 특정 세션의 전체 메시지 목록 조회 (상세 페이지 대화 내역용)
     * - c_idx ASC 정렬로 시간 순서대로 반환
     * @param chatSession 조회할 세션 번호
     */
    List<ChatbotVO> getMessageList(@Param("chatSession") int chatSession);
}
