package org.study.project05.chat.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.study.project05.chat.mapper.ChatMapper;
import org.study.project05.chat.vo.ChatVO;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChatServiceImpl implements ChatService {

    private final ChatMapper chatMapper;
    private final ChatGPTService chatGPTService;

    @Override
    public ChatVO processMessage(ChatVO chatVO) {
        // 1. 사용자 메시지 추출 및 기본값 세팅
        String userMessage = chatVO.getCMessage();
        String currentPage = chatVO.getCPage() != null ? chatVO.getCPage() : "/";

        if (chatVO.getUIdx() == null || chatVO.getUIdx() == 0L) {
            chatVO.setUIdx(1L); 
        }
        if (chatVO.getCSession() == null || chatVO.getCSession() == 0) {
            chatVO.setCSession(1001); 
        }

        // --- 시나리오 분기: 초기 진입([OPEN_CHAT]) 시 맞춤 인사 ---
        if ("[OPEN_CHAT]".equals(userMessage)) {
            String welcomeMsg = "안녕하세요! 공유 오피스의 친절한 안내원 **오피(Offy)**입니다. 무엇을 도와드릴까요?";
            if (currentPage.contains("reservation")) {
                welcomeMsg = "예약을 고민 중이신가요? 저 **오피**가 날짜나 인원수에 맞는 최적의 공간을 추천해 드릴게요! 📅";
            } else if (currentPage.contains("list") || currentPage.contains("search")) {
                welcomeMsg = "원하시는 지역이나 오피스 스타일이 있으신가요? 저 **오피**가 맞춤형 공간을 찾아드릴게요! 🏢";
            }
            
            chatVO.setCResponse(welcomeMsg);
            chatVO.setCIntent("WELCOME_GREETING");
            chatVO.setCPage(currentPage);
            return chatVO;
        }

        // 2. 대화 이력 조회 및 GPT 컨텍스트 구성
        List<ChatVO> history = chatMapper.selectChatListBySession(chatVO.getCSession());
        List<java.util.Map<String, String>> messages = new java.util.ArrayList<>();

        // 시스템 지시어 강화 (이름: 오피 반영)
        java.util.Map<String, String> systemMsg = new java.util.HashMap<>();
        systemMsg.put("role", "system");
        systemMsg.put("content", 
            "너는 공유 오피스의 스마트 안내원 '오피(Offy)'야. 아래 지침을 따라줘:\n" +
            "1. 전문적이고 친절한 한국어로 답변할 것. 모든 응답마다 자기소개를 반복할 필요는 없으며, 자연스럽게 본론부터 답변해줘.\n" +
            "2. 주요 기능: 공간 추천, 예약 방법 안내, FAQ(환불, 시설, 장단기 예약) 대응.\n" +
            "3. FAQ 정보:\n" +
            "   - 환불: 이용 3일 전 100%, 1일 전 50%, 당일 환불 불가.\n" +
            "   - 시설: 24시간 개방, 초고속 와이파이, 커피 무제한, 회의실 완비.\n" +
            "   - 예약: 앱/웹에서 실시간 가능, 1개월 이상 장기 예약 시 별도 할인.\n" +
            "4. 해결이 어려운 요청이나 직접 상담이 필요해 보이면 상단의 '직접 문의' 버튼이나 '/inquiry' 페이지를 안내해줘.\n" +
            "   - 문의 카테고리: 공간 예약, 결제 및 환불, 시설 이용, 회원정보/계정, 이용방법, 제휴 및 광고, 장애/오류 등.");
        messages.add(systemMsg);

        // 이전 대화 내역 중 최신 10개만 포함 (슬라이딩 윈도우)
        int start = Math.max(0, history.size() - 10);
        List<ChatVO> recentHistory = history.subList(start, history.size());

        for (ChatVO h : recentHistory) {
            if (h.getCMessage() != null && !"[OPEN_CHAT]".equals(h.getCMessage())) {
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
            log.error("AI Service Error for session {}: {}", chatVO.getCSession(), e.getMessage());
            botResponse = "[서비스 점검 중] 질문을 이해하지 못했습니다. 상단의 '직접 문의' 버튼을 이용해 주세요.";
        }

        // 4. 결과 세팅 및 DB 저장
        chatVO.setCResponse(botResponse);
        chatVO.setCIntent("AI_GENERATED");
        chatVO.setCPage(currentPage);
        
        chatMapper.insertChat(chatVO);

        return chatVO;
    }

    @Override
    public List<ChatVO> getChatHistory(int cSession) {
        return chatMapper.selectChatListBySession(cSession);
    }

    // 메시지 객체 생성을 위한 헬퍼 메서드 (Java 21 Map.of 활용)
    private Map<String, String> createMsg(String role, String content) {
        return Map.of("role", role, "content", content);
    }
}
