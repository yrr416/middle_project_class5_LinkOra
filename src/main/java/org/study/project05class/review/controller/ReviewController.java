package org.study.project05class.review.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.study.project05class.review.service.ReviewService;
import org.study.project05class.review.vo.ReviewReportVO;
import org.study.project05class.review.vo.ReviewVO;

import java.util.List;

/**
 * 리뷰 관리 컨트롤러
 * /admin/review/** 요청 처리
 */
@Slf4j
@Controller
@RequestMapping("/admin/review")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    /** 페이지당 리뷰 표시 수 */
    private static final int NUM_PER_PAGE   = 10;
    /** 페이지 블록당 표시 수 */
    private static final int PAGE_PER_BLOCK = 5;

    /**
     * 리뷰 관리 메인 페이지
     * GET /admin/review/list
     */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int nowPage,
                       @RequestParam(defaultValue = "1") int reportPage,
                       ReviewVO reviewVO,
                       Model model) {

        // ── 답변완료 수 ───────────────────────────────────────────
        int answeredCount = reviewService.getAnsweredReviewCount();

        // ── 리뷰 목록 페이징 계산 ──────────────────────────────────
        int totalRecord = reviewService.getReviewCount(reviewVO);
        int totalPage   = (totalRecord <= 0) ? 1
                : (int) Math.ceil((double) totalRecord / NUM_PER_PAGE);

        if (nowPage < 1) nowPage = 1;
        if (nowPage > totalPage) nowPage = totalPage;

        int offset     = (nowPage - 1) * NUM_PER_PAGE;
        int beginBlock = (int)(Math.floor((double)(nowPage - 1) / PAGE_PER_BLOCK) * PAGE_PER_BLOCK) + 1;
        int endBlock   = Math.min(beginBlock + PAGE_PER_BLOCK - 1, totalPage);

        List<ReviewVO> reviewList = reviewService.getReviewList(NUM_PER_PAGE, offset, reviewVO);

        // ── 신고 목록 페이징 계산 (PENDING 신고만) ─────────────────
        int reportTotal = reviewService.getReportCount("PENDING");
        int reportTotalPage = (reportTotal <= 0) ? 1
                : (int) Math.ceil((double) reportTotal / NUM_PER_PAGE);

        if (reportPage < 1) reportPage = 1;
        if (reportPage > reportTotalPage) reportPage = reportTotalPage;

        int reportOffset = (reportPage - 1) * NUM_PER_PAGE;
        List<ReviewReportVO> reportList = reviewService.getReportList(NUM_PER_PAGE, reportOffset, "PENDING");

        // ── 모델 바인딩 ───────────────────────────────────────────
        model.addAttribute("reviewList",      reviewList);
        model.addAttribute("totalRecord",     totalRecord);
        model.addAttribute("answeredCount",   answeredCount);
        model.addAttribute("totalPage",       totalPage);
        model.addAttribute("nowPage",         nowPage);
        model.addAttribute("beginBlock",      beginBlock);
        model.addAttribute("endBlock",        endBlock);
        model.addAttribute("reviewVO",        reviewVO);

        model.addAttribute("reportList",      reportList);
        model.addAttribute("reportTotal",     reportTotal);
        model.addAttribute("reportPage",      reportPage);
        model.addAttribute("reportTotalPage", reportTotalPage);

        return "review/list";
    }

    /**
     * 리뷰 상세 페이지
     * GET /admin/review/detail
     */
    @GetMapping("/detail")
    public String detail(@RequestParam("revIdx")                              String revIdx,
                         @RequestParam(name = "nowPage", defaultValue = "1")  int nowPage,
                         ReviewVO reviewVO,
                         Model model) {

        ReviewVO review = reviewService.getReviewDetail(revIdx);
        if (review == null) {
            return "redirect:/admin/review/list?nowPage=" + nowPage;
        }

        List<ReviewReportVO> reportList = reviewService.getReportsByRevIdx(revIdx);

        model.addAttribute("review",     review);
        model.addAttribute("reportList", reportList);
        model.addAttribute("nowPage",    nowPage);
        model.addAttribute("reviewVO",   reviewVO);

        return "review/detail";
    }

    /**
     * 관리자 답글 등록
     * POST /admin/review/reply
     */
    @PostMapping("/reply")
    public String reply(@RequestParam("revIdx")                                      String revIdx,
                        @RequestParam("reply_content")                                String replyContent,
                        @RequestParam(name = "nowPage", defaultValue = "1")          int nowPage,
                        @RequestParam(name = "fromDetail", defaultValue = "") String fromDetail,
                        ReviewVO reviewVO) {

        int result = reviewService.insertAdminReply(revIdx, replyContent);
        log.info("관리자 답글 등록 - revIdx: {}, 결과: {}", revIdx, result);

        if ("1".equals(fromDetail)) {
            return "redirect:/admin/review/detail?revIdx=" + revIdx + "&nowPage=" + nowPage;
        }
        return buildRedirect(nowPage, reviewVO);
    }

    /**
     * 관리자 답글 수정
     * POST /admin/review/replyUpdate
     */
    @PostMapping("/replyUpdate")
    public String replyUpdate(@RequestParam("revIdx")                              String revIdx,
                              @RequestParam("reply_content")                        String replyContent,
                              @RequestParam(name = "nowPage", defaultValue = "1")  int nowPage) {

        reviewService.updateAdminReply(revIdx, replyContent);
        log.info("관리자 답글 수정 - revIdx: {}", revIdx);

        return "redirect:/admin/review/detail?revIdx=" + revIdx + "&nowPage=" + nowPage;
    }

    /**
     * 관리자 답글 삭제
     * POST /admin/review/replyDelete
     */
    @PostMapping("/replyDelete")
    public String replyDelete(@RequestParam("revIdx")                             String revIdx,
                              @RequestParam(name = "nowPage", defaultValue = "1") int nowPage) {

        reviewService.deleteAdminReply(revIdx);
        log.info("관리자 답글 삭제 - revIdx: {}", revIdx);

        return "redirect:/admin/review/detail?revIdx=" + revIdx + "&nowPage=" + nowPage;
    }

    /**
     * 리뷰 삭제 (관련 답글 포함)
     * POST /admin/review/delete
     */
    @PostMapping("/delete")
    public String delete(@RequestParam("revIdx")                              String revIdx,
                         @RequestParam(name = "nowPage", defaultValue = "1")  int nowPage) {

        reviewService.deleteReview(revIdx);
        log.info("리뷰 삭제 - revIdx: {}", revIdx);

        return "redirect:/admin/review/list?nowPage=" + nowPage;
    }

    /**
     * 리뷰 블라인드 처리 (vActive = 2)
     * POST /admin/review/blind
     */
    @PostMapping("/blind")
    public String blind(@RequestParam("revIdx")                                      String revIdx,
                        @RequestParam(name = "nowPage", defaultValue = "1")          int nowPage,
                        @RequestParam(name = "fromDetail", defaultValue = "") String fromDetail,
                        ReviewVO reviewVO) {

        reviewService.blindReview(revIdx);
        log.info("리뷰 블라인드 처리 - revIdx: {}", revIdx);

        if ("1".equals(fromDetail)) {
            return "redirect:/admin/review/detail?revIdx=" + revIdx + "&nowPage=" + nowPage;
        }
        return buildRedirect(nowPage, reviewVO);
    }

    /**
     * 리뷰 블라인드 해제 (vActive = 0)
     * POST /admin/review/unblind
     */
    @PostMapping("/unblind")
    public String unblind(@RequestParam("revIdx")                                      String revIdx,
                          @RequestParam(name = "nowPage", defaultValue = "1")          int nowPage,
                          @RequestParam(name = "fromDetail", defaultValue = "") String fromDetail,
                          ReviewVO reviewVO) {

        reviewService.unblindReview(revIdx);
        log.info("리뷰 블라인드 해제 - revIdx: {}", revIdx);

        if ("1".equals(fromDetail)) {
            return "redirect:/admin/review/detail?revIdx=" + revIdx + "&nowPage=" + nowPage;
        }
        return buildRedirect(nowPage, reviewVO);
    }

    /**
     * 신고 블라인드 처리
     * POST /admin/review/reportBlind
     */
    @PostMapping("/reportBlind")
    public String reportBlind(@RequestParam("rvrIdx")                                      String rvrIdx,
                              @RequestParam("revIdx")                                       String revIdx,
                              @RequestParam("rvrAdminReply")                                String adminReply,
                              @RequestParam(name = "nowPage", defaultValue = "1")           int nowPage,
                              @RequestParam(name = "fromDetail", defaultValue = "") String fromDetail) {

        reviewService.processReportBlind(rvrIdx, revIdx, adminReply);
        log.info("신고 블라인드 처리 - rvrIdx: {}, revIdx: {}", rvrIdx, revIdx);

        if ("1".equals(fromDetail)) {
            return "redirect:/admin/review/detail?revIdx=" + revIdx + "&nowPage=" + nowPage;
        }
        return "redirect:/admin/review/list?nowPage=" + nowPage;
    }

    /**
     * 신고 반려 처리 (문제없음)
     * POST /admin/review/reportDismiss
     */
    @PostMapping("/reportDismiss")
    public String reportDismiss(@RequestParam("rvrIdx")                              String rvrIdx,
                                @RequestParam("rvrAdminReply")                        String adminReply,
                                @RequestParam(name = "nowPage", defaultValue = "1")  int nowPage) {

        reviewService.processReportDismiss(rvrIdx, adminReply);
        log.info("신고 반려 처리 - rvrIdx: {}", rvrIdx);

        return "redirect:/admin/review/list?nowPage=" + nowPage;
    }

    /**
     * 리뷰 목록 리다이렉트 URL 생성 (필터 파라미터 유지)
     */
    private String buildRedirect(int nowPage, ReviewVO reviewVO) {
        StringBuilder sb = new StringBuilder("redirect:/admin/review/list?nowPage=").append(nowPage);
        if (reviewVO.getRatingFilter() != null && !reviewVO.getRatingFilter().isEmpty()) {
            sb.append("&ratingFilter=").append(reviewVO.getRatingFilter());
        }
        if (reviewVO.getBlindFilter() != null && !reviewVO.getBlindFilter().isEmpty()) {
            sb.append("&blindFilter=").append(reviewVO.getBlindFilter());
        }
        if (reviewVO.getSearchWord() != null && !reviewVO.getSearchWord().isEmpty()) {
            sb.append("&searchWord=").append(reviewVO.getSearchWord());
        }
        return sb.toString();
    }
}
