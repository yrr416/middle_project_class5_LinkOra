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
     * - 신고 대기 목록 (PENDING) 우선 표시
     * - 전체 리뷰 목록 (별점/블라인드 필터)
     * GET /admin/review/list
     */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int nowPage,
                       @RequestParam(defaultValue = "1") int reportPage,
                       ReviewVO reviewVO,
                       Model model) {

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
     * 관리자 답글 등록
     * - 답글 INSERT → 원본 리뷰 v_active = 1 (처리완료, 관리자 페이지 숨김)
     * POST /admin/review/reply
     */
    @PostMapping("/reply")
    public String reply(@RequestParam("v_idx")        String v_idx,
                        @RequestParam("reply_content") String replyContent,
                        @RequestParam(defaultValue = "1") int nowPage,
                        ReviewVO reviewVO) {

        int result = reviewService.insertAdminReply(v_idx, replyContent);
        log.info("관리자 답글 등록 - v_idx: {}, 결과: {}", v_idx, result);

        return buildRedirect(nowPage, reviewVO);
    }

    /**
     * 리뷰 블라인드 처리 (v_active = 2)
     * POST /admin/review/blind
     */
    @PostMapping("/blind")
    public String blind(@RequestParam("v_idx") String v_idx,
                        @RequestParam(defaultValue = "1") int nowPage,
                        ReviewVO reviewVO) {

        reviewService.blindReview(v_idx);
        log.info("리뷰 블라인드 처리 - v_idx: {}", v_idx);

        return buildRedirect(nowPage, reviewVO);
    }

    /**
     * 리뷰 블라인드 해제 (v_active = 0)
     * POST /admin/review/unblind
     */
    @PostMapping("/unblind")
    public String unblind(@RequestParam("v_idx") String v_idx,
                          @RequestParam(defaultValue = "1") int nowPage,
                          ReviewVO reviewVO) {

        reviewService.unblindReview(v_idx);
        log.info("리뷰 블라인드 해제 - v_idx: {}", v_idx);

        return buildRedirect(nowPage, reviewVO);
    }

    /**
     * 신고 블라인드 처리
     * - 신고 상태 = BLINDED + 관리자 알림 메시지 저장
     * - 대상 리뷰 v_active = 2
     * POST /admin/review/reportBlind
     */
    @PostMapping("/reportBlind")
    public String reportBlind(@RequestParam("rr_idx")       String rr_idx,
                              @RequestParam("v_idx")         String v_idx,
                              @RequestParam("rr_admin_reply") String adminReply,
                              @RequestParam(defaultValue = "1") int nowPage) {

        reviewService.processReportBlind(rr_idx, v_idx, adminReply);
        log.info("신고 블라인드 처리 - rr_idx: {}, v_idx: {}", rr_idx, v_idx);

        return "redirect:/admin/review/list?nowPage=" + nowPage;
    }

    /**
     * 신고 반려 처리 (문제없음)
     * - 신고 상태 = DISMISSED + 관리자 알림 메시지 저장
     * POST /admin/review/reportDismiss
     */
    @PostMapping("/reportDismiss")
    public String reportDismiss(@RequestParam("rr_idx")        String rr_idx,
                                @RequestParam("rr_admin_reply") String adminReply,
                                @RequestParam(defaultValue = "1") int nowPage) {

        reviewService.processReportDismiss(rr_idx, adminReply);
        log.info("신고 반려 처리 - rr_idx: {}", rr_idx);

        return "redirect:/admin/review/list?nowPage=" + nowPage;
    }

    /**
     * 리뷰 목록 리다이렉트 URL 생성 (필터 파라미터 유지)
     */
    private String buildRedirect(int nowPage, ReviewVO reviewVO) {
        StringBuilder sb = new StringBuilder("redirect:/admin/review/list?nowPage=").append(nowPage);
        if (reviewVO.getRating_filter() != null && !reviewVO.getRating_filter().isEmpty()) {
            sb.append("&rating_filter=").append(reviewVO.getRating_filter());
        }
        if (reviewVO.getBlind_filter() != null && !reviewVO.getBlind_filter().isEmpty()) {
            sb.append("&blind_filter=").append(reviewVO.getBlind_filter());
        }
        if (reviewVO.getSearch_word() != null && !reviewVO.getSearch_word().isEmpty()) {
            sb.append("&search_word=").append(reviewVO.getSearch_word());
        }
        return sb.toString();
    }
}
