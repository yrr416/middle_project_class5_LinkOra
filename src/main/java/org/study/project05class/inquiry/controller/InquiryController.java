package org.study.project05class.inquiry.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.project05class.inquiry.service.InquiryService;
import org.study.project05class.inquiry.vo.InquiryVO;

import java.util.List;

/**
 * 1:1 문의 관리 컨트롤러
 * /admin/inquiry/** 요청 처리
 */
@Slf4j
@Controller
@RequestMapping("/admin/inquiry")
public class InquiryController {

    @Autowired
    private InquiryService inquiryService;

    /** 페이지당 문의 표시 수 */
    private static final int NUM_PER_PAGE   = 10;
    /** 페이지 블록당 표시 수 */
    private static final int PAGE_PER_BLOCK = 5;

    /**
     * 문의 목록 페이지
     * - 미답변(PENDING) 우선 정렬
     * - 상태 필터 (전체 / 미답변 / 답변완료)
     * - 제목/작성자 검색
     * GET /admin/inquiry/list
     */
    @GetMapping({"/list", "", "/"})
    public String list(@RequestParam(defaultValue = "1") int nowPage,
                       InquiryVO inquiryVO,
                       Model model) {

        // ── 페이징 계산 ────────────────────────────────────────────
        int totalRecord = inquiryService.getInquiryCount(inquiryVO);
        int totalPage   = (totalRecord <= 0) ? 1
                : (int) Math.ceil((double) totalRecord / NUM_PER_PAGE);

        if (nowPage < 1) nowPage = 1;
        if (nowPage > totalPage) nowPage = totalPage;

        int offset     = (nowPage - 1) * NUM_PER_PAGE;
        int beginBlock = (int)(Math.floor((double)(nowPage - 1) / PAGE_PER_BLOCK) * PAGE_PER_BLOCK) + 1;
        int endBlock   = Math.min(beginBlock + PAGE_PER_BLOCK - 1, totalPage);

        List<InquiryVO> inquiryList = inquiryService.getInquiryList(NUM_PER_PAGE, offset, inquiryVO);

        // ── 미답변 건수 (상단 알림용) ──────────────────────────────
        int pendingCount = inquiryService.getPendingCount();

        // ── 모델 바인딩 ────────────────────────────────────────────
        model.addAttribute("inquiryList",  inquiryList);
        model.addAttribute("totalRecord",  totalRecord);
        model.addAttribute("totalPage",    totalPage);
        model.addAttribute("nowPage",      nowPage);
        model.addAttribute("beginBlock",   beginBlock);
        model.addAttribute("endBlock",     endBlock);
        model.addAttribute("inquiryVO",    inquiryVO);
        model.addAttribute("pendingCount", pendingCount);

        return "inquiry/list";
    }

    /**
     * 문의 상세 조회 페이지
     * - 문의 내용 + 답변 입력창 표시
     * GET /admin/inquiry/detail?i_idx=...
     */
    @GetMapping("/detail")
    public String detail(@RequestParam String i_idx,
                         @RequestParam(defaultValue = "1") int nowPage,
                         @RequestParam(defaultValue = "") String status_filter,
                         @RequestParam(defaultValue = "") String search_word,
                         Model model) {

        // 문의 상세 데이터 조회
        InquiryVO inquiry = inquiryService.getInquiryDetail(i_idx);
        if (inquiry == null) {
            return "redirect:/admin/inquiry/list";
        }

        model.addAttribute("inquiry",       inquiry);
        model.addAttribute("nowPage",       nowPage);
        model.addAttribute("status_filter", status_filter);
        model.addAttribute("search_word",   search_word);

        return "inquiry/detail";
    }

    /**
     * 답변 저장
     * - i_answer 저장
     * - i_status 자동 COMPLETE 변경
     * - 답변 저장 후 목록으로 이동
     * POST /admin/inquiry/answer
     */
    @PostMapping("/answer")
    public String answer(@RequestParam String i_idx,
                         @RequestParam String i_answer,
                         @RequestParam(defaultValue = "false") boolean isUpdate,
                         @RequestParam(defaultValue = "1") int nowPage,
                         @RequestParam(defaultValue = "") String status_filter,
                         @RequestParam(defaultValue = "") String search_word,
                         RedirectAttributes rttr) {

        // i_answer 저장 + i_status='답변완료' + i_answered=NOW() 업데이트
        int result = inquiryService.saveAnswer(i_idx, i_answer);

        if (isUpdate) {
            // 수정: 해당 문의 상세 페이지(답변 폼)로 복귀
            log.info("문의 답변 수정 - i_idx: {}, 결과: {}", i_idx, result);
            rttr.addFlashAttribute("msg", "답변이 수정되었습니다.");
            return "redirect:/admin/inquiry/detail?i_idx=" + i_idx
                    + "&nowPage=" + nowPage
                    + "&status_filter=" + status_filter
                    + "&search_word=" + search_word
                    + "#answerForm";
        } else {
            // 신규 저장: 답변완료 탭 1페이지로 이동
            log.info("문의 답변 저장 - i_idx: {}, 결과: {}", i_idx, result);
            rttr.addFlashAttribute("msg", "답변이 저장되었습니다.");
            return "redirect:/admin/inquiry/list?nowPage=1&status_filter=답변완료";
        }
    }
}
