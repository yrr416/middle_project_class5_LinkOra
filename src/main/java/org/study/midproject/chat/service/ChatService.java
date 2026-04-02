package org.study.midproject.chat.service;

import org.study.midproject.chat.vo.ChatVO;
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
}
