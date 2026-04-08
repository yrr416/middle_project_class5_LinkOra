package org.study.project05class.chatbot.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.project05class.chatbot.service.ChatbotService;
import org.study.project05class.chatbot.vo.ChatbotVO;

import java.util.List;

/**
 * 챗봇 상담내역 관리 컨트롤러
 * /admin/chatbot/** 요청을 처리한다
 */
@Slf4j
@Controller
@RequestMapping("/admin/chatbot")
public class ChatbotController {

    @Autowired
    private ChatbotService chatbotService;

    /** 페이지 블록당 표시 수 (페이지네이션 블록 크기) */
    private static final int BLOCK_SIZE = 5;

    /**
     * 챗봇 상담 세션 목록 페이지
     * GET /admin/chatbot/list
     *
     * @param nowPage    현재 페이지 번호 (기본값 1)
     * @param numPerPage 페이지당 건수 (10 / 20 / 50, 기본값 10)
     * @param chatbotVO  검색·필터 파라미터 (searchWord, statusFilter, dateFrom, dateTo)
     */
    @GetMapping({"/list", "", "/"})
    public String list(@RequestParam(defaultValue = "1")  int nowPage,
                       @RequestParam(defaultValue = "10") int numPerPage,
                       ChatbotVO chatbotVO,
                       Model model) {

        // numPerPage 유효성 검사 (허용값: 10 / 20 / 50)
        if (numPerPage != 10 && numPerPage != 20 && numPerPage != 50) {
            numPerPage = 10;
        }

        // 전체 세션 수 및 페이징 계산
        int totalRecord = chatbotService.getSessionCount(chatbotVO);
        int totalPage   = (totalRecord <= 0) ? 1
                : (int) Math.ceil((double) totalRecord / numPerPage);

        if (nowPage < 1) nowPage = 1;
        if (nowPage > totalPage) nowPage = totalPage;

        int offset     = (nowPage - 1) * numPerPage;
        int beginBlock = (int)(Math.floor((double)(nowPage - 1) / BLOCK_SIZE) * BLOCK_SIZE) + 1;
        int endBlock   = Math.min(beginBlock + BLOCK_SIZE - 1, totalPage);

        List<ChatbotVO> sessionList = chatbotService.getSessionList(numPerPage, offset, chatbotVO);

        model.addAttribute("sessionList",  sessionList);
        model.addAttribute("totalRecord",  totalRecord);
        model.addAttribute("totalPage",    totalPage);
        model.addAttribute("nowPage",      nowPage);
        model.addAttribute("beginBlock",   beginBlock);
        model.addAttribute("endBlock",     endBlock);
        model.addAttribute("numPerPage",   numPerPage);
        model.addAttribute("chatbotVO",    chatbotVO);

        return "chatbot/list";
    }

    /**
     * 챗봇 상담 세션 상세 페이지
     * GET /admin/chatbot/detail?cSession=X
     *
     * @param cSession     조회할 세션 번호
     * @param nowPage       목록으로 돌아갈 때 사용할 현재 페이지 번호
     * @param numPerPage    목록으로 돌아갈 때 사용할 페이지당 건수
     * @param statusFilter  목록으로 돌아갈 때 유지할 상태 필터
     * @param searchWord    목록으로 돌아갈 때 유지할 검색어
     * @param dateFrom      목록으로 돌아갈 때 유지할 날짜 범위 시작
     * @param dateTo        목록으로 돌아갈 때 유지할 날짜 범위 종료
     */
    @GetMapping("/detail")
    public String detail(@RequestParam int cSession,
                         @RequestParam(defaultValue = "1")  int    nowPage,
                         @RequestParam(defaultValue = "10") int    numPerPage,
                         @RequestParam(defaultValue = "") String statusFilter,
                         @RequestParam(defaultValue = "") String searchWord,
                         @RequestParam(defaultValue = "") String dateFrom,
                         @RequestParam(defaultValue = "") String dateTo,
                         Model model) {

        // 세션 요약 정보 조회 (고객 정보 + 상담 메타)
        ChatbotVO sessionInfo = chatbotService.getSessionSummary(cSession);

        // 존재하지 않는 세션이면 목록으로 리다이렉트
        if (sessionInfo == null) {
            log.warn("존재하지 않는 챗봇 세션 접근 - cSession: {}", cSession);
            return "redirect:/admin/chatbot/list";
        }

        // 세션 내 전체 메시지 조회 (말풍선 대화 내역)
        List<ChatbotVO> messageList = chatbotService.getMessageList(cSession);

        log.info("챗봇 상담 상세 조회 - cSession: {}, 메시지 수: {}", cSession, messageList.size());

        model.addAttribute("sessionInfo",   sessionInfo);
        model.addAttribute("messageList",   messageList);
        model.addAttribute("nowPage",       nowPage);
        model.addAttribute("numPerPage",    numPerPage);
        model.addAttribute("statusFilter",  statusFilter);
        model.addAttribute("searchWord",    searchWord);
        model.addAttribute("dateFrom",      dateFrom);
        model.addAttribute("dateTo",        dateTo);

        return "chatbot/detail";
    }
}
