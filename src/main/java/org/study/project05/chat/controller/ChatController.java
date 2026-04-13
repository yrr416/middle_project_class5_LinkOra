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
    public ChatVO sendMessage(@RequestBody ChatVO chatVO, jakarta.servlet.http.HttpSession session) {
        // 1. 세션 번호 체크 및 자동 부여
        if (chatVO.getChatSession() == null || chatVO.getChatSession() == 0) {
            chatVO.setChatSession((int)(System.currentTimeMillis() % 1000000));
        }
        
        // 2. 실제 세션 정보 연동
        Object uIdxObj = session.getAttribute("userIdx");
        if (uIdxObj != null) {
            try {
                if (uIdxObj instanceof Long) {
                    chatVO.setUserIdx((Long) uIdxObj);
                } else if (uIdxObj instanceof Integer) {
                    chatVO.setUserIdx(((Integer) uIdxObj).longValue());
                } else {
                    chatVO.setUserIdx(Long.parseLong(String.valueOf(uIdxObj)));
                }
            } catch (Exception e) {
                chatVO.setUserIdx(1L); // 파싱 실패 시 테스트용
            }
        } else if (chatVO.getUserIdx() == null) {
            chatVO.setUserIdx(1L); // 로그인 안된 경우 기본값(추후 로그인 유도로 교체 가능)
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
    public List<ChatVO> getRecentHistory(@PathVariable Long userIdx, jakarta.servlet.http.HttpSession session) {
        // 보완: 세션에 유저 정보가 있다면 경로 변수보다 세션 정보를 우선시하여 보안 강화
        Object uIdxObj = session.getAttribute("userIdx");
        if (uIdxObj != null) {
             try {
                if (uIdxObj instanceof Long) userIdx = (Long) uIdxObj;
                else userIdx = Long.parseLong(String.valueOf(uIdxObj));
             } catch (Exception e) {}
        }
        if (userIdx == null || userIdx == 0) {
            userIdx = 1L; // 비회원 또는 초기 상태 시 테스트용 기본 데이터 조회
        }
        return chatService.getRecentUserHistory(userIdx);
    }
}
