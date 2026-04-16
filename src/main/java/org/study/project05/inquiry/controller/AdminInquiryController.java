package org.study.project05.inquiry.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.project05.inquiry.mapper.InquiryMapper;
import org.study.project05.inquiry.vo.InquiryVO;

import java.util.List;

/**
 * 관리자 문의 관리 컨트롤러
 * /admin/inquiry/** 요청 처리
 */
@Controller
@RequestMapping("/admin/inquiry")
public class AdminInquiryController {

    @Autowired
    private InquiryMapper inquiryMapper;

    private static final int NUM_PER_PAGE   = 15;
    private static final int PAGE_PER_BLOCK = 5;

    /**
     * 문의 목록 (GET /admin/inquiry/list)
     * statusFilter: PENDING(미답변) / COMPLETE(답변완료) / "" (전체)
     * searchWord: 제목 또는 작성자명 검색
     */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1")  int    nowPage,
                       @RequestParam(defaultValue = "")   String statusFilter,
                       @RequestParam(defaultValue = "")   String searchWord,
                       Model model) {

        String sf = statusFilter.isEmpty() ? null : statusFilter;
        String sw = searchWord.isEmpty()   ? null : searchWord;

        int totalRecord  = inquiryMapper.countAllForAdmin(sf, sw);  // 필터 적용된 수 (페이징용)
        int totalAll     = inquiryMapper.countAllForAdmin(null, sw); // 검색어만 적용 (통계 카드용)
        int pendingCount = inquiryMapper.countPending();
        int completeCount = totalAll - pendingCount;

        int totalPage = (totalRecord <= 0) ? 1
                : (int) Math.ceil((double) totalRecord / NUM_PER_PAGE);
        if (nowPage < 1) nowPage = 1;
        if (nowPage > totalPage) nowPage = totalPage;

        int offset     = (nowPage - 1) * NUM_PER_PAGE;
        int beginBlock = (int)(Math.floor((double)(nowPage - 1) / PAGE_PER_BLOCK) * PAGE_PER_BLOCK) + 1;
        int endBlock   = Math.min(beginBlock + PAGE_PER_BLOCK - 1, totalPage);

        List<InquiryVO> inquiryList = inquiryMapper.selectAllForAdmin(sf, sw, offset, NUM_PER_PAGE);

        // JSP에서 inquiryVO.statusFilter / inquiryVO.searchWord 로 접근
        InquiryVO inquiryVO = new InquiryVO();
        inquiryVO.setStatusFilter(statusFilter);
        inquiryVO.setSearchWord(searchWord);

        model.addAttribute("inquiryList",   inquiryList);
        model.addAttribute("inquiryVO",     inquiryVO);
        model.addAttribute("totalRecord",   totalRecord);
        model.addAttribute("totalAll",      totalAll);
        model.addAttribute("pendingCount",  pendingCount);
        model.addAttribute("completeCount", completeCount);
        model.addAttribute("nowPage",      nowPage);
        model.addAttribute("totalPage",    totalPage);
        model.addAttribute("beginBlock",   beginBlock);
        model.addAttribute("endBlock",     endBlock);

        return "inquiry/list";
    }

    /**
     * 문의 상세 (GET /admin/inquiry/detail)
     */
    @GetMapping("/detail")
    public String detail(@RequestParam("inqIdx")                  Integer inqIdx,
                         @RequestParam(defaultValue = "1")  int           nowPage,
                         @RequestParam(defaultValue = "")   String        statusFilter,
                         @RequestParam(defaultValue = "")   String        searchWord,
                         Model model) {

        InquiryVO inquiry = inquiryMapper.selectInquiryDetail(inqIdx);
        if (inquiry == null) {
            return "redirect:/admin/inquiry/list";
        }

        model.addAttribute("inquiry",      inquiry);
        model.addAttribute("nowPage",      nowPage);
        model.addAttribute("statusFilter", statusFilter);
        model.addAttribute("searchWord",   searchWord);

        return "inquiry/detail";
    }

    /**
     * 답변 저장 (POST /admin/inquiry/answer)
     */
    @PostMapping("/answer")
    public String answer(@RequestParam("inqIdx")                   Integer inqIdx,
                         @RequestParam("inqAnswer")                String  inqAnswer,
                         @RequestParam(defaultValue = "1")  int            nowPage,
                         @RequestParam(defaultValue = "")   String         statusFilter,
                         @RequestParam(defaultValue = "")   String         searchWord,
                         RedirectAttributes ra) {

        inquiryMapper.answerInquiry(inqIdx, inqAnswer);
        ra.addFlashAttribute("msg", "답변이 저장되었습니다.");
        return "redirect:/admin/inquiry/list?nowPage=" + nowPage
                + "&statusFilter=" + statusFilter
                + "&searchWord=" + searchWord;
    }
}
