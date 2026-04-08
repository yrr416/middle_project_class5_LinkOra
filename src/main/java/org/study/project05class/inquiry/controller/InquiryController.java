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
     * GET /admin/inquiry/list
     */
    @GetMapping({"/list", "", "/"})
    public String list(@RequestParam(defaultValue = "1") int nowPage,
                       InquiryVO inquiryVO,
                       Model model) {

        int totalRecord = inquiryService.getInquiryCount(inquiryVO);
        int totalPage   = (totalRecord <= 0) ? 1
                : (int) Math.ceil((double) totalRecord / NUM_PER_PAGE);

        if (nowPage < 1) nowPage = 1;
        if (nowPage > totalPage) nowPage = totalPage;

        int offset     = (nowPage - 1) * NUM_PER_PAGE;
        int beginBlock = (int)(Math.floor((double)(nowPage - 1) / PAGE_PER_BLOCK) * PAGE_PER_BLOCK) + 1;
        int endBlock   = Math.min(beginBlock + PAGE_PER_BLOCK - 1, totalPage);

        List<InquiryVO> inquiryList = inquiryService.getInquiryList(NUM_PER_PAGE, offset, inquiryVO);

        int pendingCount = inquiryService.getPendingCount();

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
     * GET /admin/inquiry/detail?iIdx=...
     */
    @GetMapping("/detail")
    public String detail(@RequestParam String inqIdx,
                         @RequestParam(defaultValue = "1") int nowPage,
                         @RequestParam(defaultValue = "") String statusFilter,
                         @RequestParam(defaultValue = "") String searchWord,
                         Model model) {

        InquiryVO inquiry = inquiryService.getInquiryDetail(inqIdx);
        if (inquiry == null) {
            return "redirect:/admin/inquiry/list";
        }

        model.addAttribute("inquiry",       inquiry);
        model.addAttribute("nowPage",       nowPage);
        model.addAttribute("statusFilter",  statusFilter);
        model.addAttribute("searchWord",    searchWord);

        return "inquiry/detail";
    }

    /**
     * 답변 저장
     * POST /admin/inquiry/answer
     */
    @PostMapping("/answer")
    public String answer(@RequestParam String inqIdx,
                         @RequestParam String inqAnswer,
                         @RequestParam(defaultValue = "false") boolean isUpdate,
                         @RequestParam(defaultValue = "1") int nowPage,
                         @RequestParam(defaultValue = "") String statusFilter,
                         @RequestParam(defaultValue = "") String searchWord,
                         RedirectAttributes rttr) {

        int result = inquiryService.saveAnswer(inqIdx, inqAnswer);

        if (isUpdate) {
            log.info("문의 답변 수정 - inqIdx: {}, 결과: {}", inqIdx, result);
            rttr.addFlashAttribute("msg", "답변이 수정되었습니다.");
        } else {
            log.info("문의 답변 저장 - inqIdx: {}, 결과: {}", inqIdx, result);
            rttr.addFlashAttribute("msg", "답변이 저장되었습니다.");
        }

        rttr.addAttribute("nowPage", nowPage);
        if (statusFilter != null && !statusFilter.isEmpty()) {
            rttr.addAttribute("statusFilter", statusFilter);
        }
        if (searchWord != null && !searchWord.isEmpty()) {
            rttr.addAttribute("searchWord", searchWord);
        }
        return "redirect:/admin/inquiry/list";
    }
}
