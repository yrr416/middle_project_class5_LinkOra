package org.study.project05.chat.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.study.project05.chat.service.ChatService;
import org.study.project05.chat.vo.ChatVO;
import org.study.project05.reservation.user.service.UserReservationService;
import org.study.project05.reservation.user.vo.UserReservationVO;
import org.study.project05.branch.service.SpaceBranchService;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Slf4j
@RestController
@RequestMapping("/chat")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;
    private final UserReservationService userReservationService;
    private final SpaceBranchService branchService;

    /**
     * 클라이언트로부터 메시지를 받아 실시간 응답 반환
     */
    @PostMapping("/send")
    public ChatVO sendMessage(@RequestBody ChatVO chatVO, jakarta.servlet.http.HttpSession session) {
        // 1. 세션 번호 체크 및 자동 부여
        if (chatVO.getChatSession() == null || chatVO.getChatSession() == 0) {
            chatVO.setChatSession((int)(System.currentTimeMillis() % 1000000));
        }
        
        // 2. 세션 정보 또는 시큐리티 인증 정보 연동
        Long userIdx = null;

        // 1. Spring Security ContextHolder에서 인증 정보 확인
        org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && ! (auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken)) {
            Object principal = auth.getPrincipal();
            if (principal instanceof org.study.project05.login.config.CustomUserDetails userDetails) {
                userIdx = userDetails.getIdx();
                // [복구 강화] 세션 유실 방지를 위해 세션에 정보 다시 주입 (매 요청마다 동기화)
                session.setAttribute("userIdx", userIdx);
                session.setAttribute("userName", userDetails.getRealName());
                log.debug("[ChatController] Restored session from SecurityContext: {}", userIdx);
            }
        }

        // 2. 세션에서 userIdx 추출 (시큐리티 정보가 없는 경우 폴백)
        if (userIdx == null) {
            Object uIdxObj = session.getAttribute("userIdx");
            if (uIdxObj != null) {
                try {
                    if (uIdxObj instanceof Integer) userIdx = ((Integer) uIdxObj).longValue();
                    else if (uIdxObj instanceof Long) userIdx = (Long) uIdxObj;
                    else userIdx = Long.parseLong(String.valueOf(uIdxObj));
                } catch (Exception e) {
                    log.error("[ChatController] UserIdx parsing error: " + e.getMessage());
                }
            }
        }

        if (userIdx != null && userIdx > 0) {
            chatVO.setUserIdx(userIdx);
        } else {
            chatVO.setUserIdx(null); // Guest
        }
        
        // 3. 비회원 보안을 위한 세션 ID 기록
        chatVO.setHttpSessionId(session.getId());
        
        return chatService.processMessage(chatVO);
    }

    /**
     * 특정 세션의 대화 내역 조회 (보안 검증 포함)
     */
    @GetMapping("/history/{chatSession}")
    public List<ChatVO> getHistory(@PathVariable int chatSession, jakarta.servlet.http.HttpSession session) {
        Long userIdx = 0L;
        Object uIdxObj = session.getAttribute("userIdx");
        if (uIdxObj != null) {
            try {
                if (uIdxObj instanceof Long) userIdx = (Long) uIdxObj;
                else userIdx = Long.parseLong(String.valueOf(uIdxObj));
            } catch (Exception e) {
                log.warn("getHistory userIdx 파싱 실패 - 값: {}, 원인: {}", uIdxObj, e.getMessage());
            }
        }
        return chatService.getChatHistory(chatSession, userIdx, session.getId());
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
             } catch (Exception e) {
                log.warn("getRecentHistory userIdx 파싱 실패 - 값: {}, 원인: {}", uIdxObj, e.getMessage());
             }
        }
        if (userIdx == null || userIdx == 0) {
            userIdx = 1L; // 비회원 또는 초기 상태 시 테스트용 기본 데이터 조회
        }
        return chatService.getRecentUserHistory(userIdx);
    }

    /** 챗봇을 통한 실시간 예약 선점 (1단계) - 기본을 ONLINE으로 설정하여 이탈 시 자동취소 환경 구축 */
    @PostMapping("/reserve")
    public Map<String, Object> chatbotReserve(@RequestBody UserReservationVO vo, jakarta.servlet.http.HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            // --- [보완] 사용자 식별 로직 강화 (Spring Security 인증 정보 우선 참조) ---
            Long userIdx = null;

            // 1. Spring Security ContextHolder에서 인증 정보 확인
            org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && ! (auth instanceof org.springframework.security.authentication.AnonymousAuthenticationToken)) {
                Object principal = auth.getPrincipal();
                if (principal instanceof org.study.project05.login.config.CustomUserDetails userDetails) {
                    userIdx = userDetails.getIdx();
                }
                log.info("[ChatController] Security Authenticated User: " + auth.getName());
            }

            // 2. 세션에서 userIdx 추출 (기존 방식 유지 및 보완)
            Object uIdxObj = session.getAttribute("userIdx");
            if (uIdxObj != null) {
                try {
                    if (uIdxObj instanceof Integer) {
                        userIdx = ((Integer) uIdxObj).longValue();
                    } else if (uIdxObj instanceof Long) {
                        userIdx = (Long) uIdxObj;
                    } else if (uIdxObj instanceof String) {
                        userIdx = Long.parseLong((String) uIdxObj);
                    }
                } catch (Exception e) {
                    log.error("[ChatController] UserIdx parsing error: " + e.getMessage());
                }
            }

            if (userIdx == null) {
                response.put("success", false);
                response.put("message", "로그인 후 이용 가능합니다.");
                return response;
            }
            
            vo.setUserIdx(userIdx.intValue());
            vo.setPaymentType("ONLINE"); // [안전장치] 기본을 ONLINE으로 생성하여 미결제 이탈 시 10분 후 자동취소되게 함
            
            userReservationService.reserve(vo);
            
            response.put("success", true);
            response.put("resIdx", vo.getResIdx());
        } catch (Exception e) {
            log.error("챗봇 예약 생성 오류: {}", e.getMessage());
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    /** 결제 수단 선택 시 DB 동기화 및 일반 결제 시스템 세션 주입 (2단계) */
    @PostMapping("/payment-ready")
    public Map<String, Object> chatbotPaymentReady(@RequestBody Map<String, Object> payload, jakarta.servlet.http.HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            int resIdx = Integer.parseInt(String.valueOf(payload.get("resIdx")));
            String type = (String) payload.get("paymentType");
            
            // 1. DB 업데이트 (ONLINE 또는 OFFLINE)
            userReservationService.updatePaymentType(resIdx, type);
            
            // 2. 온라인 결제의 경우, 기존 PaymentController가 요구하는 세션값 사전 주입 (중요)
            if ("ONLINE".equals(type)) {
                UserReservationVO vo = userReservationService.getReservationById(resIdx);
                if (vo != null) {
                    session.setAttribute("pendingResIdx",     vo.getResIdx());
                    session.setAttribute("pendingAmount",     Integer.parseInt(vo.getResTotalPrice()));
                    session.setAttribute("pendingSpaceName",  branchService.getSpaceById(vo.getSpcIdx()).getSpcName());
                    session.setAttribute("pendingStartTime",  vo.getResStartTime());
                    session.setAttribute("pendingEndTime",    vo.getResEndTime());
                    log.info("[Chatbot] Online payment session primed for ResIdx: {}", resIdx);
                }
            }
            
            response.put("success", true);
        } catch (Exception e) {
            log.error("챗봇 결제 동기화 오류: {}", e.getMessage());
            response.put("success", false);
        }
        return response;
    }
}
