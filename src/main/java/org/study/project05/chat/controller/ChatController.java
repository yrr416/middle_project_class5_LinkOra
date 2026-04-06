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
        // 실제로는 세션 관리 로직 등이 추가되어야 함 (현재는 테스트 코드 중심)
        if (chatVO.getCSession() == 0) {
            chatVO.setCSession(1001); // 기본 세션 ID 부여 (임시)
        }
        return chatService.processMessage(chatVO);
    }

    /**
     * 특정 세션의 대화 내역 조회
     */
    @GetMapping("/history/{cSession}")
    public List<ChatVO> getHistory(@PathVariable int cSession) {
        return chatService.getChatHistory(cSession);
    }
}
