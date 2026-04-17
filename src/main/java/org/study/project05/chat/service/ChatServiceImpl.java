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
    private final org.study.project05.reservation.user.service.UserReservationService reservationService;
    private final org.study.project05.branch.mapper.BranchMapper branchMapper;
    private final org.study.project05.branch.mapper.BranchDetailSpaceMapper spaceMapper;
    private final org.study.project05.branch.mapper.FacilityMapper facilityMapper;

    @Override
    public ChatVO processMessage(ChatVO chatVO) {
        // 1. 사용자 메시지 추출 및 기본값 세팅
        String userMessage = chatVO.getChatMessage();
        String currentPage = chatVO.getChatPage() != null ? chatVO.getChatPage() : "/";

        if (chatVO.getUserIdx() == null || chatVO.getUserIdx() <= 0L) {
            chatVO.setUserIdx(0L);
        }
        if (chatVO.getChatSession() == null || chatVO.getChatSession() == 0) {
            chatVO.setChatSession(1001);
        }

        // --- 시나리오 분기: 초기 진입([OPEN_CHAT]) 시 맞춤 인사 ---
        if ("[OPEN_CHAT]".equals(userMessage)) {
            String welcomeMenu = "[[WELCOME_MENU:공간 추천 및 안내|🏢 공간 추천 및 안내|🏢, 예약 안내|📅 예약 안내|📅, 자주 묻는 질문|❓ 자주 묻는 질문|❓]]";
            String welcomeMsg = "안녕하세요! 공유 오피스의 친절한 안내원 오피(Offy)입니다. 무엇을 도와드릴까요? " + welcomeMenu;

            if (currentPage.contains("reservation")) {
                welcomeMsg = "예약을 고민 중이신가요? 저 오피가 날짜나 인원수에 맞는 최적의 공간을 추천해 드릴게요! 📅 " + welcomeMenu;
            } else if (currentPage.contains("list") || currentPage.contains("search")) {
                welcomeMsg = "원하시는 지역이나 오피스 스타일이 있으신가요? 저 오피가 맞춤형 공간을 찾아드릴게요! 🏢 " + welcomeMenu;
            }

            chatVO.setChatResponse(welcomeMsg);
            chatVO.setChatIntent("WELCOME_GREETING");
            chatVO.setChatPage(currentPage);

            // 초기 환영 인사를 DB에 저장하여 대화 이력을 생성 (중복 노출 방지 핵심)
            try {
                // DB 저장용 길이 제한 및 전처리
                chatVO.setChatMessage("[OPEN_CHAT]");
                chatMapper.insertChat(chatVO);
            } catch (Exception e) {
                log.error("Initial Greeting Insert Failure: {}", e.getMessage());
            }

            return chatVO;
        }

        // 2. 대화 이력 조회 및 GPT 컨텍스트 구성 (보안 검증 파라미터 포함)
        List<ChatVO> history = chatMapper.selectChatListBySession(chatVO.getChatSession(), chatVO.getUserIdx(), chatVO.getHttpSessionId());
        List<java.util.Map<String, String>> messages = new java.util.ArrayList<>();

        // 시스템 지시어 강화
        java.util.Map<String, String> systemMsg = new java.util.HashMap<>();
        systemMsg.put("role", "developer");

        // 실시간 공간 정보 컨텍스트 생성 (지점명, 공간명, ID 매핑 + 시설 + 가용성)
        String reservationContext = getReservationContext(chatVO.getLat(), chatVO.getLng());
        String today = java.time.LocalDate.now().toString();

        systemMsg.put("content",
                "너는 공유 오피스의 인공지능 예약 에이전트 '오피(Offy)'야. 아래 [기능별 준수 지침]을 최우선으로 따라줘:\n" +
                        "[강력 준수 지침 - 예약 및 취소]\n" +
                        "1. **회원 전용 기능**: 예약(`COMMIT_BOOKING`) 및 취소(`CANCEL_BOOKING`)는 로그인한 회원만 가능해. 만약 사용자 ID가 0(Guest)이라면 \"회원 전용 기능입니다. 로그인 후 이용해 주세요\"라고 안내하고 로그인을 유도해.\n" +
                        "2. **실시간 정보 동기화 (Smart Prefill)**: 대화 도중 날짜, 시간, 인원수가 언급되면 즉시 `[[PREFILL:yyyy-MM-dd|시작|종료]]` 태그를 답변 끝에 포함해. 이건 비회원에게도 보여줘.\n" +
                        "3. **명령 실행 필수 (중요)**: 예약을 최종 확정할 때는 `[[COMMIT_BOOKING:공간ID|시작T시각|종료T시각|인원]]`를, 취소할 때는 `[[CANCEL_BOOKING:예약ID]]` 태그를 답변에 **반드시** 포함해야 시스템에 반영돼. 태그 없이 말로만 성공했다고 하지 마.\n" +
                        "4. **취소 권한 관련 (필독)**: 사용자가 자신의 예약을 취소해달라고 하면, 해당 예약의 상태가 **'대기중(신청 완료)'** 또는 **'확정됨(이용 가능)'**인 경우 아무런 제약 없이 즉시 `[[CANCEL_BOOKING:예약ID]]` 태그를 생성하여 취소를 진행해줘.\n" +
                        "5. **확정 유도**: 텍스트 확정보다는 카드 UI의 **'바로예약' -> '공간 예약하기'** 순서로 유도해.\n" +
                        "\n[새로운 추천 시나리오 - 공간 추천]\n" +
                        "1. **위치 기반 추천**: 사용자가 '공간 추천'을 요청하면 [공간 정보 컨텍스트]에서 **가장 상단에 있는(가까운) 3개의 공간**을 `[[ACTIONS:공간ID|공간명|지점명|이미지|시설요약|가격|공간타입|지점ID]]` 태그로 보여줘. '지점ID'는 컨텍스트의 BrnID 값을 사용해.\n" +
                        "2. **후속 대화 유도**: 추천 카드를 보여준 직후에는 반드시 \"몇 분이서 이용하시나요?\", \"주차나 24시간 이용 등 특별히 필요한 시설이 있으신가요?\"라고 질문하여 필터링을 구체화해.\n" +
                        "3. **정밀 추천**: 사용자가 인원이나 시설 조건을 말하면 해당 조건에 맞는 공간을 다시 검색하여 보여줘.\n" +
                        "\n[일반 운영 지침]\n" +
                        "1. **환영 메뉴 및 중복 금지**: 대화 이력에 봇의 메시지가 이미 존재한다면 대화 도중 `[[WELCOME_MENU:...]]`를 다시 사용하지 마.\n" +
                        "2. **예약 안내 (통합 관리 메뉴)**: 사용자가 '예약 안내'를 요청하면 즉시 다음 서브메뉴 카드를 보여줘:\n" +
                        "   - `[[WELCOME_MENU:예약하기|신규 예약하기|📅, 예약확인|예약 현황 확인|📝, 예약취소|진행 중인 예약 취소|❌]]`\n" +
                        "3. **말투**: 전문적이고 친절한 한국어. 마크다운(`*`, `-`, `#`) 사용 금지.\n" +
                        "\n[실시간 가용성 확인 지침]\n" +
                        "1. 사용자가 특정 공간의 '예약 가능 여부', '남은 자리', '가용성' 등을 물어보면 즉시 `[[CHECK_AVAILABILITY:공간ID|yyyy-MM-dd]]` 태그를 답변에 포함해.\n" +
                        "2. 이 태그를 통해 시스템이 해당 날짜의 시간대별 잔여 좌석표를 자동으로 생성하여 사용자에게 완벽한 정보를 제공할 수 있어.\n" +
                        "\n[공간 정보 컨텍스트]\n" +
                        reservationContext + "\n" +
                        "[현재 사용자 상태]\n" +
                        (chatVO.getUserIdx() == 0L ? "현재 비로그인(Guest) 상태입니다. 예약 시 로그인이 필요함을 안내하세요." : "로그인된 회원(ID:" + chatVO.getUserIdx() + ")입니다.") + "\n" +
                        "[사용자 예약 현황]\n" +
                        getUserReservationsContext(chatVO.getUserIdx()) + "\n" +
                        "환불 규정: 3일 전 100%, 1일 전 50%.\n" +
                        "[중요 안내 지침]\n" +
                        "- 위 예약 현황이 비어 있다면 사용자에게 '현재 진행 중인 예약이 없다'고만 답변하고, 불필요하게 날짜나 시간을 다시 묻지 마세요.");

        messages.add(systemMsg);

        // 이전 대화 내역 중 최신 10개만 포함
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

        // --- [추가] 사용자 메시지에 포함된 다이렉트 예약 실행 태그 처리 ---
        String executionResult = null;
        if (userMessage.contains("[[COMMIT_BOOKING:")) {
            executionResult = executeDirectReservation(userMessage, chatVO.getUserIdx());
        }

        // 현재 사용자 메시지 추가
        messages.add(createMsg("user", userMessage));

        // 예약 결과가 있다면 시스템 피드백으로 추가 (AI가 답변 시 참고하도록)
        if (executionResult != null) {
            messages.add(createMsg("developer", "[시스템 메시지] 예약 처리 결과: " + executionResult +
                    "\n위의 정보를 바탕으로 사용자에게 예약 확정 안내를 해주세요. 예약 번호와 가격을 반드시 명시하세요."));
        }
        String botResponse;
        try {
            botResponse = chatGPTService.chat(messages);

            // --- 지능형 예약 명령어 핸들링 ---
            // [고도화] 인텐트 결정을 핸들링 전의 원본 botResponse 및 사용자 메시지 기준으로 분석 (우선순위 체계 적용)
            String rawResponse = botResponse != null ? botResponse : "";
            String rawUserMsg = userMessage != null ? userMessage : "";
            String determinedIntent = "AI_CONVERSATION";

            // 1. 최우선 순위: 실제 예약 확정 및 취소
            if (rawUserMsg.contains("[[COMMIT_BOOKING:") || rawResponse.contains("[[COMMIT_BOOKING:")) {
                determinedIntent = "BOOKING_COMMIT";
            } else if (rawUserMsg.contains("[[CANCEL_BOOKING:") || rawResponse.contains("[[CANCEL_BOOKING:")) {
                determinedIntent = "BOOKING_CANCEL";
            }
            // 2. 예약 프로세스 진입 및 가용성 확인
            else if (rawResponse.contains("[[PREFILL:")) {
                determinedIntent = "BOOKING_PREFILL";
            } else if (rawResponse.contains("[[CHECK_AVAILABILITY:")) {
                determinedIntent = "AVAILABILITY_CHECK";
            }
            // 3. 공간 추천 및 FAQ 안내
            else if (rawResponse.contains("[[ACTIONS:")) {
                determinedIntent = "RECOMMEND_SPACE";
            } else if (rawUserMsg.contains("자주 묻는 질문") || rawUserMsg.contains("FAQ") || rawResponse.contains("자주 묻는 질문")) {
                determinedIntent = "FAQ_INQUIRY";
            }

            chatVO.setChatIntent(determinedIntent);



            if (botResponse.contains("[[CHECK_AVAILABILITY:")) {
                botResponse = handleAvailabilityCheck(botResponse);
            } else if (botResponse.contains("[[COMMIT_BOOKING:")) {
                botResponse = handleCommitBooking(botResponse, chatVO.getUserIdx());
            } else if (botResponse.contains("[[CANCEL_BOOKING:")) {
                botResponse = handleCancelBooking(botResponse, chatVO.getUserIdx());
            }

        } catch (Exception e) {
            log.error("AI Service Error: {}", e.getMessage());
            botResponse = "[서비스 점검 중] 질문을 이해하지 못했습니다. 상단의 '직접 문의' 버튼을 이용해 주세요.";
            chatVO.setChatIntent("AI_CONVERSATION");
        }

        // 4. 결과 세팅 및 DB 저장용 길이 제한
        chatVO.setChatResponse(botResponse);
        chatVO.setChatPage(currentPage);

        // --- DB 저장용 객체 전처리 (500자 Truncation) ---

        String safeMessage = (userMessage != null && userMessage.length() > 2000)
                ? userMessage.substring(0, 2000)
                : userMessage;
        String safeResponse = (botResponse != null && botResponse.length() > 2000)
                ? botResponse.substring(0, 2000)
                : botResponse;

        chatVO.setChatMessage(safeMessage);
        chatVO.setChatResponse(safeResponse);

        try {
            chatMapper.insertChat(chatVO);
        } catch (Exception e) {
            log.error("Database Insert Failure: {}", e.getMessage());
        }

        // 브라우저에는 자르지 않은 원본 답변을 전달하여 사용자 경험 유지
        chatVO.setChatResponse(botResponse);
        return chatVO;
    }

    @Override
    public List<ChatVO> getChatHistory(int chatSession, Long userIdx, String httpSessionId) {
        return chatMapper.selectChatListBySession(chatSession, userIdx, httpSessionId);
    }

    @Override
    public List<ChatVO> getRecentUserHistory(Long userIdx) {
        return chatMapper.selectRecentChatByUser(userIdx);
    }

    private String handleAvailabilityCheck(String botResponse) {
        try {
            int startIdx = botResponse.indexOf("[[CHECK_AVAILABILITY:");
            int endIdx = botResponse.indexOf("]]", startIdx);
            String tag = botResponse.substring(startIdx, endIdx + 2);
            String content = tag.replace("[[CHECK_AVAILABILITY:", "").replace("]]", "");
            String[] parts = content.split("\\|");

            int spcIdx = Integer.parseInt(parts[0].replace("#", "").trim());
            String date = parts[1].trim();

            org.study.project05.branch.vo.BranchSpaceVO space = spaceMapper.selectById(spcIdx);
            int maxCap = space.getSpcMaxCapacity();
            java.util.Map<Integer, Integer> remaining = reservationService.getRemainingSeats(spcIdx, date, maxCap);

            StringBuilder sb = new StringBuilder();
            sb.append("\n📊 [ ").append(date).append(" 실시간 현황 ]\n");
            sb.append("-----------------------------\n");
            for (int h = 9; h <= 21; h++) {
                int seats = remaining.getOrDefault(h, maxCap);
                String status = (seats > 0) ? "🟢 " + seats + "석" : "🔴 마감";
                sb.append(String.format("%02d:00 | %s\n", h, status));
            }
            sb.append("-----------------------------\n");
            return botResponse.replace(tag, sb.toString());
        } catch (Exception e) {
            return botResponse.replaceAll("\\[\\[CHECK_AVAILABILITY:.*?\\]\\]", "\n(현재 가용성 조회가 불가능합니다.)");
        }
    }

    private String handleCommitBooking(String botResponse, Long userIdx) {
        try {
            int startIdx = botResponse.indexOf("[[COMMIT_BOOKING:");
            int endIdx = botResponse.indexOf("]]", startIdx);
            String tag = botResponse.substring(startIdx, endIdx + 2);

            // [정책 추가] 예약은 회원만 가능함
            if (userIdx == null || userIdx <= 0L) {
                return botResponse.replace(tag, "\n\n⚠️ 예약은 회원 서비스입니다. 로그인 후 이용해 주시면 즉시 예약을 도와드릴게요! 😊");
            }

            String content = tag.replace("[[COMMIT_BOOKING:", "").replace("]]", "");
            String[] parts = content.split("\\|");

            org.study.project05.reservation.user.vo.UserReservationVO vo = new org.study.project05.reservation.user.vo.UserReservationVO();
            vo.setSpcIdx(Integer.parseInt(parts[0].replace("#", "").trim()));

            // 날짜 정보가 누락되고 시간(HH:mm)만 넘어온 경우 처리
            String todayPrefix = java.time.LocalDate.now().toString();
            String startTime = parts[1].length() <= 5 ? todayPrefix + "T" + parts[1] : parts[1];
            String endTime = parts[2].length() <= 5 ? todayPrefix + "T" + parts[2] : parts[2];

            vo.setResStartTime(startTime);
            vo.setResEndTime(endTime);
            vo.setResHeadcount(Integer.parseInt(parts[3].replace("#", "").trim()));
            vo.setUserIdx(userIdx != null ? userIdx.intValue() : 1);

            reservationService.reserve(vo);

            String successMsg = "\n\n✔️ 예약 신청이 성공적으로 완료되었습니다!\n" +
                    "- 예약 번호: #" + vo.getResIdx() + "\n" +
                    "- 총 결제 금액: " + vo.getResTotalPrice() + "원\n" +
                    "관리자 확인 후 예약이 최종 확정됩니다. 이메일 또는 예약 내역에서 상태를 확인해 주세요. 😊";

            return botResponse.replace(tag, successMsg);
        } catch (Exception e) {
            return botResponse.replaceAll("\\[\\[COMMIT_BOOKING:.*?\\]\\]", "\n\n❌ 예약 실패: " + e.getMessage());
        }
    }

    private String handleCancelBooking(String botResponse, Long userIdx) {
        try {
            int startIdx = botResponse.indexOf("[[CANCEL_BOOKING:");
            int endIdx = botResponse.indexOf("]]", startIdx);
            String tag = botResponse.substring(startIdx, endIdx + 2);

            // [정책 추가] 취소는 회원만 가능함
            if (userIdx == null || userIdx <= 0L) {
                return botResponse.replace(tag, "\n\n⚠️ 예약 취소는 로그인 후 본인 확인을 거쳐야 가능합니다.");
            }

            String resIdxStr = tag.replace("[[CANCEL_BOOKING:", "").replace("]]", "");
            int resIdx = Integer.parseInt(resIdxStr.replace("#", "").trim());
            org.study.project05.reservation.user.vo.UserReservationVO vo = new org.study.project05.reservation.user.vo.UserReservationVO();
            vo.setResIdx(resIdx);
            vo.setUserIdx(userIdx.intValue());

            reservationService.cancelReservation(resIdx, userIdx.intValue());

            String successMsg = "\n\n✔️ 예약이 취소되었습니다. (예약번호: #" + resIdx + ")\n환불 규정에 따라 처리가 진행됩니다.";
            return botResponse.replace(tag, successMsg);
        } catch (Exception e) {
            return botResponse.replaceAll("\\[\\[CANCEL_BOOKING:.*?\\]\\]", "\n\n❌ 취소 실패: " + e.getMessage());
        }
    }

    /**
     * 사용자 메시지에서 직접 예약 태그를 추출하여 실행
     */
    private String executeDirectReservation(String userMessage, Long userIdx) {
        try {
            int startIdx = userMessage.indexOf("[[COMMIT_BOOKING:");
            int endIdx = userMessage.indexOf("]]", startIdx);
            String content = userMessage.substring(startIdx + 17, endIdx);
            String[] parts = content.split("\\|");

            org.study.project05.reservation.user.vo.UserReservationVO vo = new org.study.project05.reservation.user.vo.UserReservationVO();
            vo.setSpcIdx(Integer.parseInt(parts[0].replace("#", "").trim()));

            String todayPrefix = java.time.LocalDate.now().toString();
            String startTime = parts[1].length() <= 5 ? todayPrefix + "T" + parts[1] : parts[1];
            String endTime = parts[2].length() <= 5 ? todayPrefix + "T" + parts[2] : parts[2];

            vo.setResStartTime(startTime);
            vo.setResEndTime(endTime);
            vo.setResHeadcount(Integer.parseInt(parts[3].replace("#", "").trim()));
            vo.setUserIdx(userIdx != null ? userIdx.intValue() : 1);

            reservationService.reserve(vo);

            return "성공 (예약번호: #" + vo.getResIdx() + ", 총액: " + vo.getResTotalPrice() + "원)";
        } catch (Exception e) {
            log.error("executeDirectReservation Error: ", e);
            return "실패 (사유: " + e.getMessage() + ")";
        }
    }

    private Map<String, String> createMsg(String role, String content) {
        Map<String, String> msg = new HashMap<>();
        msg.put("role", role);
        msg.put("content", content != null ? content : "");
        return msg;
    }

    private String getReservationContext(Double lat, Double lng) {
        try {
            String today = java.time.LocalDate.now().toString();

            // 위치 정보가 있으면 필터 검색(거리순 상위 3개), 없으면 전체 목록 사용
            List<org.study.project05.branch.vo.BranchVO> branches;
            if (lat != null && lng != null) {
                // 파라미터 개수를 15개로 수정함 (type 자리에 null 추가)
                branches = branchMapper.searchWithFilters(null, null, null, null, null, null, null, null, null, null, null, lat, lng, 0, 3);
            } else {
                branches = branchMapper.getAllBranches();
            }

            StringBuilder sb = new StringBuilder();
            for (org.study.project05.branch.vo.BranchVO b : branches) {
                String distInfo = (b.getDistance() > 0) ? String.format("(%.1fkm 거리) ", b.getDistance()) : "";
                sb.append("- ").append(b.getBrnName()).append(distInfo).append(":\n");

                List<org.study.project05.branch.vo.BranchSpaceVO> spaces = spaceMapper.selectByBranch(b.getBrnIdx());
                for (org.study.project05.branch.vo.BranchSpaceVO s : spaces) {
                    // 시설 정보 가져오기
                    org.study.project05.branch.vo.FacilityVO f = facilityMapper.selectBySpaceIdx(s.getSpcIdx());
                    String facInfos = (f != null) ? getFacilitySummary(f) : "기본 시설";

                    // 가용성 체크 (단순화: 오늘 14시 기준 좌석 유무)
                    int maxCap = s.getSpcMaxCapacity();
                    java.util.Map<Integer, Integer> seats = reservationService.getRemainingSeats(s.getSpcIdx(), today, maxCap);
                    int currentSeats = seats.getOrDefault(14, maxCap);

                    sb.append("  * ").append(s.getSpcName())
                            .append(" (ID:").append(s.getSpcIdx())
                            .append(", 시설:").append(facInfos)
                            .append(", 상태:").append(currentSeats > 0 ? "예약가능" : "매진")
                            .append(", 이미지:").append(s.getSpcImg() != null ? s.getSpcImg() : "default_office.png")
                            .append(", 가격:").append(s.getSpcPrice())
                            .append(", 타입:").append(s.getSpcType())
                            .append(", BrnID:").append(b.getBrnIdx())
                            .append(")\n");
                }
            }
            return sb.toString();
        } catch (Exception e) {
            log.error("getReservationContext Error: ", e);
            return "현재 지점 정보 로드 실패: " + e.getMessage();
        }
    }

    private String getFacilitySummary(org.study.project05.branch.vo.FacilityVO f) {
        StringBuilder fs = new StringBuilder();
        // 0/1(Integer) 기반 체크로 수정 및 7종 시설 지원
        if (Integer.valueOf(1).equals(f.getFacParking())) fs.append("주차,");
        if (Integer.valueOf(1).equals(f.getFacHours24())) fs.append("24H,");
        if (Integer.valueOf(1).equals(f.getFacPet())) fs.append("펫동반,");
        if (Integer.valueOf(1).equals(f.getFacCafe())) fs.append("카페,");
        if (Integer.valueOf(1).equals(f.getFacLounge())) fs.append("라운지,");

        // 추가 시설 필터
        if (Integer.valueOf(1).equals(f.getFacDisplay())) fs.append("모니터,");
        if (Integer.valueOf(1).equals(f.getFacStorage())) fs.append("사물함,");

        if (fs.length() > 0) fs.setLength(fs.length() - 1);
        return fs.toString();
    }


    private String getUserReservationsContext(Long userIdx) {
        if (userIdx == null || userIdx <= 0L) return "가입 후 첫 예약을 진행해 보세요!"; // 게스트인 경우 내역 조회 스킵

        try {
            List<org.study.project05.reservation.user.vo.UserReservationVO> list = reservationService.getMyReservations(userIdx.intValue());
            StringBuilder sb = new StringBuilder();
            java.time.LocalDateTime now = java.time.LocalDateTime.now();

            // 다양한 날짜 형식을 지원하기 위한 포매터 (공백 및 T 대응)
            java.time.format.DateTimeFormatter fmt = new java.time.format.DateTimeFormatterBuilder()
                    .append(java.time.format.DateTimeFormatter.ISO_LOCAL_DATE)
                    .optionalStart().appendLiteral(' ').optionalEnd()
                    .optionalStart().appendLiteral('T').optionalEnd()
                    .append(java.time.format.DateTimeFormatter.ISO_LOCAL_TIME)
                    .toFormatter();

            boolean hasActive = false;
            for (org.study.project05.reservation.user.vo.UserReservationVO r : list) {
                try {
                    String startTimeStrRaw = r.getResStartTime();
                    String endTimeStrRaw = r.getResEndTime();
                    if (startTimeStrRaw == null || endTimeStrRaw == null) continue;

                    // 파싱 전 전처리: 초(:ss)가 없는 경우(16자) 대응
                    String startTimeStr = startTimeStrRaw.length() == 16 ? startTimeStrRaw + ":00" : startTimeStrRaw;
                    String endTimeStr = endTimeStrRaw.length() == 16 ? endTimeStrRaw + ":00" : endTimeStrRaw;

                    java.time.LocalDateTime startTime = java.time.LocalDateTime.parse(startTimeStr, fmt);
                    java.time.LocalDateTime endTime = java.time.LocalDateTime.parse(endTimeStr, fmt);

                    // 종료 시간이 현재보다 미래인 것만 포함 (지난 예약 제외)
                    if (endTime.isBefore(now)) continue;

                    if (!hasActive) {
                        sb.append("당신의 진행 중인 예약 목록:\n");
                        hasActive = true;
                    }

                    String statusKor = ("PENDING".equalsIgnoreCase(r.getResStatus())) ? "대기중(신청 완료)" :
                            ("CONFIRMED".equalsIgnoreCase(r.getResStatus())) ? "확정됨(이용 가능)" : "취소됨";

                    sb.append("- #").append(r.getResIdx())
                            .append(": ").append(r.getSpaceName())
                            .append(" (").append(startTime.format(java.time.format.DateTimeFormatter.ofPattern("MM.dd HH:mm")))
                            .append("~").append(endTime.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm")))
                            .append(")")
                            .append(", 상태: ").append(statusKor).append("\n");
                } catch (Exception e) {
                    log.warn("Reservation date parsing failed for ID #{}: {}", r.getResIdx(), e.getMessage());
                    continue;
                }
            }
            return hasActive ? sb.toString() : "현재 진행 중인 예약 내역이 없습니다.";
        } catch (Exception e) {
            return "내역 조회 오류: " + e.getMessage();
        }
    }
}