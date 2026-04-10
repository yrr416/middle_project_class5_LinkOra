package org.study.project05.review.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.study.project05.member.vo.UserProfileVO;
import org.study.project05.review.service.ReviewService;

import java.util.Map;

@Controller
@RequestMapping("/review")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    /** 지점 이용후기 목록 (AJAX GET) */
    @GetMapping("/list")
    @ResponseBody
    public Map<String, Object> list(@RequestParam int brnIdx,
                                    @RequestParam(defaultValue = "1") int page) {
        return reviewService.getReviewPage(brnIdx, page);
    }

    /** 이용후기 등록 (로그인 필요) */
    @PostMapping("/write")
    @ResponseBody
    public Map<String, Object> write(@RequestParam int spcIdx,
                                     @RequestParam String content,
                                     @RequestParam Integer rating,
                                     HttpSession session) {
        UserProfileVO user = (UserProfileVO) session.getAttribute("loginUser");
        if (user == null) {
            return Map.of("success", false, "message", "로그인이 필요합니다.");
        }
        try {
            reviewService.writeReview(spcIdx, user.getUserIdx(), content, rating);
            return Map.of("success", true);
        } catch (IllegalArgumentException e) {
            return Map.of("success", false, "message", e.getMessage());
        }
    }

    /** 본인 리뷰 삭제 (로그인 필요, AJAX POST) */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam int revIdx, HttpSession session) {
        UserProfileVO user = (UserProfileVO) session.getAttribute("loginUser");
        if (user == null) {
            return Map.of("success", false, "message", "로그인이 필요합니다.");
        }
        try {
            reviewService.deleteReview(revIdx, user.getUserIdx());
            return Map.of("success", true);
        } catch (IllegalArgumentException e) {
            return Map.of("success", false, "message", e.getMessage());
        }
    }

    /**
     * 리뷰 신고 (로그인 필요)
     * AJAX POST: { revIdx, reason } → { success, message }
     */
    @PostMapping("/report")
    @ResponseBody
    public Map<String, Object> report(@RequestParam int revIdx,
                                      @RequestParam(required = false, defaultValue = "") String reason,
                                      HttpSession session) {
        UserProfileVO user = (UserProfileVO) session.getAttribute("loginUser");
        if (user == null) {
            return Map.of("success", false, "message", "로그인이 필요합니다.");
        }
        try {
            reviewService.reportReview(revIdx, user.getUserIdx(), reason);
            return Map.of("success", true, "message", "신고가 접수되었습니다.");
        } catch (IllegalStateException e) {
            return Map.of("success", false, "message", e.getMessage());
        }
    }

    /** 답글 등록 (ADMIN만) */
    @PostMapping("/reply")
    @ResponseBody
    public Map<String, Object> reply(@RequestParam int spcIdx,
                                     @RequestParam int revParentIdx,
                                     @RequestParam String content,
                                     HttpSession session) {
        UserProfileVO user = (UserProfileVO) session.getAttribute("loginUser");
        if (!"ADMIN".equals(user.getRole())) {
            return Map.of("success", false, "message", "파트너 담당자만 답글을 작성할 수 있습니다.");
        }
        try {
            reviewService.writeReply(spcIdx, revParentIdx, user.getUserIdx(), content);
            return Map.of("success", true);
        } catch (IllegalArgumentException e) {
            return Map.of("success", false, "message", e.getMessage());
        }
    }
}
