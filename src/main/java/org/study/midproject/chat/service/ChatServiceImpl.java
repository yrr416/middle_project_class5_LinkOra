package org.study.midproject.chat.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.study.midproject.chat.mapper.ChatMapper;
import org.study.midproject.chat.vo.ChatVO;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final ChatMapper chatMapper;
    private final ChatGPTService chatGPTService;

    @Override
    public ChatVO processMessage(ChatVO chatVO) {
        // 1. 사용자 메시지 추출 및 기본값 세팅
        String userMessage = chatVO.getCMessage();
        if (chatVO.getUIdx() == null || chatVO.getUIdx() == 0) {
            chatVO.setUIdx(1); // 기본 사용자 ID (비로그인/테스트용)
        }
        if (chatVO.getCSession() == null || chatVO.getCSession() == 0) {
            chatVO.setCSession(1001); // 기본 세션 ID
        }

        // 2. 대화 이력 조회 및 GPT 컨텍스트 구성
        List<ChatVO> history = chatMapper.selectChatListBySession(chatVO.getCSession());
        List<java.util.Map<String, String>> messages = new java.util.ArrayList<>();

        // 시스템 지시어 추가
        java.util.Map<String, String> systemMsg = new java.util.HashMap<>();
        systemMsg.put("role", "system");
        systemMsg.put("content", "너는 공유 오피스 'Antigravity'의 스마트 안내원이야. 친절하고 전문적으로 답변해줘. 답변은 반드시 한국어로 해.");
        messages.add(systemMsg);

        // 이전 대화 내역(History) 추가: 한 행의 (메시지+응답)을 두 개의 메시지로 변환
        for (ChatVO h : history) {
            if (h.getCMessage() != null && !h.getCMessage().isEmpty()) {
                messages.add(createMsg("user", h.getCMessage()));
            }
            if (h.getCResponse() != null && !h.getCResponse().isEmpty()) {
                messages.add(createMsg("assistant", h.getCResponse()));
            }
        }

        // 현재 사용자 메시지 추가
        messages.add(createMsg("user", userMessage));

        // 3. GPT API 호출
        String botResponse;
        try {
            botResponse = chatGPTService.chat(messages);
        } catch (Exception e) {
            botResponse = "[AI 응답 오류] 잠시 후 다시 시도해주세요. (" + e.getMessage() + ")";
        }

        // 4. 결과 세팅 및 DB 저장
        chatVO.setCResponse(botResponse);
        chatVO.setCIntent("AI_GENERATED");
        chatVO.setCPage(chatVO.getCPage() != null ? chatVO.getCPage() : "CHATBOT");
        
        chatMapper.insertChat(chatVO);

        return chatVO;
    }

    @Override
    public List<ChatVO> getChatHistory(int cSession) {
        return chatMapper.selectChatListBySession(cSession);
    }

    // 메시지 객체 생성을 위한 헬퍼 메서드
    private java.util.Map<String, String> createMsg(String role, String content) {
        java.util.Map<String, String> msg = new java.util.HashMap<>();
        msg.put("role", role);
        msg.put("content", content);
        return msg;
    }
}
