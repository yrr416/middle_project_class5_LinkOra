package org.study.project05.review.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.project05.review.mapper.ReviewMapper;
import org.study.project05.review.vo.ReviewReportVO;
import org.study.project05.review.vo.ReviewVO;

import java.util.List;
import java.util.Map;

/**
 * 관리자 리뷰 관리 컨트롤러
 * /admin/review/** 요청 처리
 */
@Controller
@RequestMapping("/admin/review")
public class AdminReviewController {

    @Autowired
    private ReviewMapper reviewMapper;

    private static final int NUM_PER_PAGE   = 15;
    private static final int PAGE_PER_BLOCK = 5;

    /**
     * 리뷰 목록 (GET /admin/review/list)
     * searchWord: 작성자명·공간명·내용으로 검색
     */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1")  int    nowPage,
                       @RequestParam(defaultValue = "")   String searchWord,
                       Model model) {

        int totalRecord = reviewMapper.countAll(searchWord.isEmpty() ? null : searchWord);

        int totalPage = (totalRecord <= 0) ? 1
                : (int) Math.ceil((double) totalRecord / NUM_PER_PAGE);
        if (nowPage < 1) nowPage = 1;
        if (nowPage > totalPage) nowPage = totalPage;

        int offset     = (nowPage - 1) * NUM_PER_PAGE;
        int beginBlock = (int)(Math.floor((double)(nowPage - 1) / PAGE_PER_BLOCK) * PAGE_PER_BLOCK) + 1;
        int endBlock   = Math.min(beginBlock + PAGE_PER_BLOCK - 1, totalPage);

        List<ReviewVO> reviewList = reviewMapper.selectAllForAdmin(
                searchWord.isEmpty() ? null : searchWord, offset, NUM_PER_PAGE);

        model.addAttribute("reviewList",   reviewList);
        model.addAttribute("totalRecord",  totalRecord);
        model.addAttribute("totalPage",    totalPage);
        model.addAttribute("nowPage",      nowPage);
        model.addAttribute("beginBlock",   beginBlock);
        model.addAttribute("endBlock",     endBlock);
        model.addAttribute("searchWord",   searchWord);

        return "review/admin_list";
    }

    /**
     * 신고 목록 조회 (GET /admin/review/reports?revIdx=X)  — AJAX JSON 응답
     */
    @GetMapping("/reports")
    @ResponseBody
    public List<ReviewReportVO> getReports(@RequestParam int revIdx) {
        return reviewMapper.selectReportsByRevIdx(revIdx);
    }

    /**
     * 리뷰 강제 삭제 (POST /admin/review/delete)
     */
    @PostMapping("/delete")
    public String delete(@RequestParam("revIdx") int revIdx,
                         @RequestParam(defaultValue = "1")  int    nowPage,
                         @RequestParam(defaultValue = "")   String searchWord) {
        reviewMapper.deleteReportsByRevIdx(revIdx);
        reviewMapper.deleteByAdmin(revIdx);
        return "redirect:/admin/review/list?nowPage=" + nowPage
                + "&searchWord=" + searchWord;
    }
}
