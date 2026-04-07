package org.study.project05.chat.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.study.project05.chat.service.ChatService;
import org.study.project05.chat.vo.ChatVO;
import java.util.List;

@RestController
@RequestMapping("/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

    /**
     * 클라이언트로부터 메시지를 받아 실시간 응답 반환
     */
    @PostMapping("/send")
    public ChatVO sendMessage(@RequestBody ChatVO chatVO) {
        // 1. 세션 번호 체크 및 자동 부여
        if (chatVO.getChatSession() == null || chatVO.getChatSession() == 0) {
            chatVO.setChatSession((int)(System.currentTimeMillis() % 1000000));
        }
        
        // 2. 사용자 ID 체크 (로그인 연동 전까지 기본값 1L 부여)
        if (chatVO.getUserIdx() == null) {
            chatVO.setUserIdx(1L);
        }
        
        return chatService.processMessage(chatVO);
    }

    /**
     * 특정 세션의 대화 내역 조회
     */
    @GetMapping("/history/{chatSession}")
    public List<ChatVO> getHistory(@PathVariable int chatSession) {
        return chatService.getChatHistory(chatSession);
    }

    /**
     * 사용자별 최근 대화 내역 조회 (하이브리드 세션용)
     */
    @GetMapping("/recent/{userIdx}")
    public List<ChatVO> getRecentHistory(@PathVariable Long userIdx) {
        return chatService.getRecentUserHistory(userIdx);
    }
}
