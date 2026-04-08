package org.study.project05class.chatbot.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05class.chatbot.mapper.ChatbotMapper;
import org.study.project05class.chatbot.vo.ChatbotVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 챗봇 상담내역 서비스 구현 클래스
 * MyBatis Mapper 에 전달할 파라미터를 Map 으로 묶어서 호출한다
 */
@Service
public class ChatbotServiceImpl implements ChatbotService {

    @Autowired
    private ChatbotMapper chatbotMapper;

    /**
     * 페이징·검색·필터 파라미터를 Map 으로 묶어 Mapper 에 전달하는 공통 헬퍼
     * @param numPerPage 페이지당 건수
     * @param offset     조회 시작 위치
     * @param vo         검색·필터 VO
     */
    private Map<String, Object> buildParams(int numPerPage, int offset, ChatbotVO vo) {
        Map<String, Object> map = new HashMap<>();
        map.put("chatbotVO",  vo);
        map.put("numPerPage", numPerPage);
        map.put("offset",     offset);
        return map;
    }

    /** 전체 세션 수 반환 (페이지 수 계산에 사용) */
    @Override
    public int getSessionCount(ChatbotVO chatbotVO) {
        return chatbotMapper.getSessionCount(buildParams(0, 0, chatbotVO));
    }

    /** 세션 목록 조회 - 페이징 및 검색/필터 조건 적용 */
    @Override
    public List<ChatbotVO> getSessionList(int numPerPage, int offset, ChatbotVO chatbotVO) {
        return chatbotMapper.getSessionList(buildParams(numPerPage, offset, chatbotVO));
    }

    /** 세션 요약 정보 조회 - 상세 페이지 상단 패널용 */
    @Override
    public ChatbotVO getSessionSummary(int c_session) {
        return chatbotMapper.getSessionSummary(c_session);
    }

    /** 세션 전체 메시지 조회 - 말풍선 대화 내역 표시용 */
    @Override
    public List<ChatbotVO> getMessageList(int c_session) {
        return chatbotMapper.getMessageList(c_session);
    }
}
