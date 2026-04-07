package org.study.project05.chat.service;

import org.study.project05.chat.vo.ChatVO;
import java.util.List;

public interface ChatService {
    /**
     * 사용자의 메시지를 처리하고 봇의 응답을 반환
     * @param chatVO 사용자 메시지 정보
     * @return 봇 응답이 포함된 ChatVO
     */
    ChatVO processMessage(ChatVO chatVO);

    /**
     * 세션별 대화 이력 조회
     * @param cSession 세션 ID
     * @return 대화 리스트
     */
    List<ChatVO> getChatHistory(int cSession);

    /**
     * 사용자별 최근 대화 내역 조회 (하이브리드 세션용)
     * @param userIdx 사용자 ID
     * @return 최근 대화 리스트
     */
    List<ChatVO> getRecentUserHistory(Long userIdx);
}
