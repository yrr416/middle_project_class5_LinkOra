package org.study.project05.chat.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.study.project05.chat.mapper.ChatMapper;
import org.study.project05.chat.vo.ChatVO;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChatServiceImpl implements ChatService {

    private final ChatMapper chatMapper;
    private final ChatGPTService chatGPTService;
    
    // 예약 시스템 연동을 위한 서비스 주입
    private final org.study.project05.reservation.user.service.ReservaionService reservationService;
    private final org.study.project05.space.mapper.BranchMapper branchMapper;
    private final org.study.project05.space.mapper.SpaceMapper spaceMapper;

    @Override
    public ChatVO processMessage(ChatVO chatVO) {
        // 1. 사용자 메시지 추출 및 기본값 세팅
        String userMessage = chatVO.getChatMessage();
        String currentPage = chatVO.getChatPage() != null ? chatVO.getChatPage() : "/";

        if (chatVO.getUserIdx() == null || chatVO.getUserIdx() == 0L) {
            chatVO.setUserIdx(1L); 
        }
        if (chatVO.getChatSession() == null || chatVO.getChatSession() == 0) {
            chatVO.setChatSession(1001); 
        }

        // --- 시나리오 분기: 초기 진입([OPEN_CHAT]) 시 맞춤 인사 ---
        if ("[OPEN_CHAT]".equals(userMessage)) {
            String welcomeMsg = "안녕하세요! 공유 오피스의 친절한 안내원 오피(Offy)입니다. 무엇을 도와드릴까요?";
            if (currentPage.contains("reservation")) {
                welcomeMsg = "예약을 고민 중이신가요? 저 오피가 날짜나 인원수에 맞는 최적의 공간을 추천해 드릴게요! 📅";
            } else if (currentPage.contains("list") || currentPage.contains("search")) {
                welcomeMsg = "원하시는 지역이나 오피스 스타일이 있으신가요? 저 오피가 맞춤형 공간을 찾아드릴게요! 🏢";
            }
            
            chatVO.setChatResponse(welcomeMsg);
            chatVO.setChatIntent("WELCOME_GREETING");
            chatVO.setChatPage(currentPage);
            return chatVO;
        }

        // 2. 대화 이력 조회 및 GPT 컨텍스트 구성
        List<ChatVO> history = chatMapper.selectChatListBySession(chatVO.getChatSession());
        List<java.util.Map<String, String>> messages = new java.util.ArrayList<>();

        // 시스템 지시어 강화 (최신 모델 사양: role을 'developer'로 설정)
        java.util.Map<String, String> systemMsg = new java.util.HashMap<>();
        systemMsg.put("role", "developer");
        
        // 실시간 공간 정보 컨텍스트 생성 (지점명, 공간명, ID 매핑)
        String reservationContext = getReservationContext();
        
        systemMsg.put("content", 
            "너는 공유 오피스의 스마트 예약 에이전트 '오피(Offy)'야. 아래 지침을 반드시 지켜줘:\n" +
            "1. 전문적이고 친절한 한국어로 답변할 것. 마크다운 형식(** 등) 금지.\n" +
            "2. 너는 실시간 예약/조회 권한이 있는 '실행형 AI'다. '시스템상 번호 제공이 안 된다'는 거짓말은 절대 금지.\n" +
            "3. 예약 확정 시 임무 (중요):\n" +
            "   - 사용자가 예약을 결정하면, 지체 없이 답변 끝에 [[COMMIT_BOOKING:공간ID|시작시간|종료시간|인원]] 태그를 붙여.\n" +
            "   - 데이터 구분자는 반드시 파이프(|) 기호를 사용해.\n" +
            "   - 시작/종료시간 형식: YYYY-MM-DDTHH:mm (예: 2026-04-10T14:00)\n" +
            "   - 이 태그가 없으면 실제 예약이 등록되지 않으므로 예약 완료 답변에는 100% 확률로 태그를 달아야 함.\n" +
            "4. 예시:\n" +
            "   - 조회 시: '현황을 확인해 드릴게요. [[CHECK_AVAILABILITY:10|2026-04-10]]'\n" +
            "   - 완료 시: '예약을 완료했습니다! 즐거운 업무 되세요. [[COMMIT_BOOKING:10|2026-04-10T12:00|2026-04-10T18:00|1]]'\n" +
            "5. 현재 지점 정보:\n" +
            reservationContext + "\n" +
            "6. FAQ 정보: 환불(3일 전 100%, 1일 전 50%), 시설(24시간, 카페, 회의실).");
        messages.add(systemMsg);

        // 이전 대화 내역 중 최신 10개만 포함 (슬라이딩 윈도우)
        int start = Math.max(0, history.size() - 10);
        List<ChatVO> recentHistory = history.subList(start, history.size());

        for (ChatVO h : recentHistory) {
            if (h.getChatMessage() != null && !"[OPEN_CHAT]".equals(h.getChatMessage())) {
                messages.add(createMsg("user", h.getChatMessage()));
            }
            if (h.getChatResponse() != null && !h.getChatResponse().isEmpty()) {
                messages.add(createMsg("assistant", h.getChatResponse()));
            }
        }

        // 현재 사용자 메시지 추가
        messages.add(createMsg("user", userMessage));

        // 3. GPT API 호출
        String botResponse;
        try {
            botResponse = chatGPTService.chat(messages);
            
            // --- 지능형 예약 명령어 핸들링 (Post-AI Processing) ---
            if (botResponse.contains("[[CHECK_AVAILABILITY:")) {
                botResponse = handleAvailabilityCheck(botResponse);
            } else if (botResponse.contains("[[COMMIT_BOOKING:")) {
                botResponse = handleCommitBooking(botResponse, chatVO.getUserIdx());
            }
            
        } catch (Exception e) {
            log.error("AI Service Error for session {}: {}", chatVO.getChatSession(), e.getMessage());
            botResponse = "[서비스 점검 중] 질문을 이해하지 못했습니다. 상단의 '직접 문의' 버튼을 이용해 주세요.";
        }

        // 4. 결과 세팅 및 DB 저장용 길이 제한 (사용자님 DB 설정상 최대 500자)
        chatVO.setChatResponse(botResponse);
        chatVO.setChatIntent("AI_GENERATED");
        chatVO.setChatPage(currentPage);
        
        // --- DB 저장용 객체 전처리 (500자 Truncation) ---
        String safeMessage = (userMessage != null && userMessage.length() > 500) 
                             ? userMessage.substring(0, 500) : userMessage;
        String safeResponse = (botResponse != null && botResponse.length() > 500) 
                              ? botResponse.substring(0, 500) : botResponse;

        chatVO.setChatMessage(safeMessage);
        chatVO.setChatResponse(safeResponse);

        try {
            log.info("[Chat DB Insert Check] session={}, userIdx={}, intent={}, responseLen={}", 
                     chatVO.getChatSession(), chatVO.getUserIdx(), chatVO.getChatIntent(), 
                     (botResponse != null ? botResponse.length() : 0));
            chatMapper.insertChat(chatVO);
        } catch (Exception e) {
            // DB 저장이 실패하더라도(길이 초과 등) 이미 생성된 답변은 브라우저로 무조건 전달
            log.error("Database Insert Failure for session {}: {}", chatVO.getChatSession(), e.getMessage());
        }

        // 브라우저에는 자르지 않은 원본 답변을 전달하여 사용자 경험 유지
        chatVO.setChatResponse(botResponse);
        return chatVO;
    }

    @Override
    public List<ChatVO> getChatHistory(int chatSession) {
        return chatMapper.selectChatListBySession(chatSession);
    }

    /** GPT의 가용성 조회 요청을 실제 DB 데이터로 변환 */
    private String handleAvailabilityCheck(String botResponse) {
        log.info("[CHAT_RESERVATION] Availability check detected in bot response.");
        try {
            // 태그 형식: [[CHECK_AVAILABILITY:공간ID|날짜(YYYY-MM-DD)]]
            int startIdx = botResponse.indexOf("[[CHECK_AVAILABILITY:");
            int endIdx = botResponse.indexOf("]]", startIdx);
            String tag = botResponse.substring(startIdx, endIdx + 2);
            String content = tag.replace("[[CHECK_AVAILABILITY:", "").replace("]]", "");
            String[] parts = content.split("\\|");
            
            int spcIdx = Integer.parseInt(parts[0]);
            String date = parts[1];
            
            log.info("[CHAT_RESERVATION] Querying availability for spaceIdx: {}, date: {}", spcIdx, date);

            // 공간 정보 조회 (최대 수용 인원 확인용)
            org.study.project05.space.vo.SpaceVO space = spaceMapper.selectById(spcIdx);
            int maxCap = Integer.parseInt(space.getSpcMaxCapacity());

            // 실시간 잔여 좌석 조회
            java.util.Map<Integer, Integer> remaining = reservationService.getRemainingSeats(spcIdx, date, maxCap);
            
            // 답변 구성
            StringBuilder sb = new StringBuilder();
            sb.append("\n[ ").append(date).append(" 실시간 예약 현황 ]\n");
            for (int h = 9; h <= 21; h++) { // 주요 대여 시간(9시~21시)만 노출
                int seats = remaining.getOrDefault(h, maxCap);
                sb.append(String.format("- %02d:00: %s\n", h, (seats > 0 ? "예약 가능 (" + seats + "석 남음)" : "예약 마감")));
            }
            sb.append("\n원하시는 시간과 인원수를 말씀해 주시면 예약을 도와드릴까요?");

            return botResponse.replace(tag, sb.toString());
        } catch (Exception e) {
            log.error("Availability Check Error: {}", e.getMessage());
            return botResponse.replaceAll("\\[\\[CHECK_AVAILABILITY:.*?\\]\\]", "\n(현재 해당 공간의 실시간 조회가 어렵습니다. 날짜와 시간을 다시 확인해 주세요.)");
        }
    }

    /** GPT의 최종 예약 요청을 처리하고 DB에 반영 */
    private String handleCommitBooking(String botResponse, Long userIdx) {
        log.info("[CHAT_RESERVATION] Commit booking request detected in bot response.");
        try {
            // 태그 형식: [[COMMIT_BOOKING:공간ID|시작시간|종료시간|인원]]
            int startIdx = botResponse.indexOf("[[COMMIT_BOOKING:");
            int endIdx = botResponse.indexOf("]]", startIdx);
            String tag = botResponse.substring(startIdx, endIdx + 2);
            String content = tag.replace("[[COMMIT_BOOKING:", "").replace("]]", "");
            String[] parts = content.split("\\|");

            log.info("[CHAT_RESERVATION] Parsed Booking Data: spcIdx={}, start={}, end={}, headcount={}", 
                      parts[0], parts[1], parts[2], parts[3]);

            org.study.project05.reservation.user.vo.ReservationVO vo = new org.study.project05.reservation.user.vo.ReservationVO();
            vo.setSpcIdx(Integer.parseInt(parts[0]));
            vo.setResStartTime(parts[1]);
            vo.setResEndTime(parts[2]);
            vo.setResHeadcount(Integer.parseInt(parts[3]));
            vo.setUserIdx(userIdx != null ? userIdx.intValue() : 1); // 서비스 기본값 1(임시)

            // 실제 예약 수행 (Exception 발생 시 catch로 이동)
            reservationService.reserve(vo);

            log.info("[CHAT_RESERVATION] DB Insert Successful! Generated resIdx: {}", vo.getResIdx());

            String successMsg = "\n\n✔️ 예약이 성공적으로 확정되었습니다!\n" +
                                "- 예약 번호: #" + vo.getResIdx() + "\n" +
                                "- 확정 금액: " + vo.getResTotalPrice() + "원\n" +
                                "내 예약 정보는 나중에 마이페이지에서도 확인해 보실 수 있어요. 😊";

            return botResponse.replace(tag, successMsg);
        } catch (IllegalArgumentException e) {
            // 중복 예약 등 비즈니스 예외 처리
            return botResponse.replaceAll("\\[\\[COMMIT_BOOKING:.*?\\]\\]", "\n\n❌ 예약 실패: " + e.getMessage() + "\n시간이나 인원을 다시 조정해 주시겠어요?");
        } catch (Exception e) {
            log.error("Commit Booking Error: {}", e.getMessage());
            return botResponse.replaceAll("\\[\\[COMMIT_BOOKING:.*?\\]\\]", "\n\n❌ 시스템 오류로 예약을 처리하지 못했습니다. 잠시 후 다시 시도해 주세요.");
        }
    }

    /** GPT 메시지 객체 생성을 위한 헬퍼 메서드 */
    private Map<String, String> createMsg(String role, String content) {
        Map<String, String> msg = new HashMap<>();
        msg.put("role", role);
        msg.put("content", content != null ? content : "");
        return msg;
    }

    /** GPT에게 제공할 실시간 지점/공간 정보 컨텍스트 생성 */
    private String getReservationContext() {
        try {
            List<org.study.project05.space.vo.BranchVO> branches = branchMapper.selectAll();
            StringBuilder sb = new StringBuilder();
            for (org.study.project05.space.vo.BranchVO b : branches) {
                sb.append("- ").append(b.getBrnName()).append(":\n");
                List<org.study.project05.space.vo.SpaceVO> spaces = spaceMapper.selectByBranch(b.getBrnIdx());
                for (org.study.project05.space.vo.SpaceVO s : spaces) {
                    sb.append("  * ").append(s.getSpcName())
                      .append(" (ID:").append(s.getSpcIdx()).append(", 타입:").append(s.getSpcType())
                      .append(", 가격:").append(s.getSpcPrice()).append("원/시간)\n");
                }
            }
            return sb.toString();
        } catch (Exception e) {
            log.warn("Failed to load reservation context: {}", e.getMessage());
            return "현재 지점 정보를 불러올 수 없습니다.";
        }
    }
}
