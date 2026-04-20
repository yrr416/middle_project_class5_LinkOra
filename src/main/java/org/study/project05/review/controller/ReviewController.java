package org.study.project05.review.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.study.project05.member.vo.UserProfileVO;
import org.study.project05.review.service.ReviewService;

import java.io.File;
import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

@Controller
@RequestMapping("/review")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;

    /** 마이페이지 리뷰 관리 (/review/management) */
    @GetMapping("/management")
    public String management(HttpSession session, Model model) {
        UserProfileVO user = (UserProfileVO) session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/loginPage";
        }
        model.addAttribute("reviewList", reviewService.getMyReviews(user.getUserIdx()));
        return "review/mylist";
    }

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
                                     @RequestParam(required = false) MultipartFile imgFile,
                                     HttpSession session,
                                     HttpServletRequest request) {
        UserProfileVO user = (UserProfileVO) session.getAttribute("loginUser");
        if (user == null) {
            return Map.of("success", false, "message", "로그인이 필요합니다.");
        }
        try {
            String imgUrl = null;
            if (imgFile != null && !imgFile.isEmpty()) {
                imgUrl = saveReviewImage(imgFile, request);
            }
            reviewService.writeReview(spcIdx, user.getUserIdx(), content, rating, imgUrl);
            return Map.of("success", true);
        } catch (IllegalArgumentException e) {
            return Map.of("success", false, "message", e.getMessage());
        } catch (IOException e) {
            return Map.of("success", false, "message", "이미지 업로드에 실패했습니다.");
        }
    }

    // 허용된 이미지 확장자 목록 (소문자로 비교)
    // .jsp, .sh, .exe 같은 실행 파일 업로드를 막기 위해 화이트리스트 방식 사용
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif", "webp");

    /**
     * 리뷰 이미지를 /static/upload/review/ 에 저장하고 파일명을 반환
     * JSP에서 contextPath + /static/upload/review/ + 파일명 으로 접근
     */
    private String saveReviewImage(MultipartFile file, HttpServletRequest request) throws IOException {
        String ext = StringUtils.getFilenameExtension(file.getOriginalFilename());

        // 확장자가 없거나 허용 목록에 없으면 업로드 거부
        // 악의적 사용자가 .jsp/.sh 등을 올려 서버에서 실행되는 것을 방지
        if (ext == null || !ALLOWED_EXTENSIONS.contains(ext.toLowerCase())) {
            throw new IllegalArgumentException("이미지 파일만 업로드 가능합니다. (jpg, jpeg, png, gif, webp)");
        }

        String uploadDir = request.getServletContext().getRealPath("/static/upload/review/");
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        String fileName = UUID.randomUUID().toString() + "." + ext.toLowerCase();
        file.transferTo(new File(dir, fileName));
        return fileName;
    }

    /** 본인 리뷰 수정 (로그인 필요, AJAX POST) */
    @PostMapping("/update")
    @ResponseBody
    public Map<String, Object> update(@RequestParam int revIdx,
                                      @RequestParam String content,
                                      @RequestParam Integer rating,
                                      @RequestParam(required = false) MultipartFile imgFile,
                                      @RequestParam(defaultValue = "false") boolean removeImg,
                                      HttpSession session,
                                      HttpServletRequest request) {
        UserProfileVO user = (UserProfileVO) session.getAttribute("loginUser");
        if (user == null) {
            return Map.of("success", false, "message", "로그인이 필요합니다.");
        }
        try {
            // imgUrl 결정:
            //   1) 새 파일이 있으면 → 저장 후 새 파일명
            //   2) removeImg=true 이면 → "" (빈 문자열 = 이미지 삭제)
            //   3) 둘 다 아니면 → null (기존 이미지 유지)
            String imgUrl = null;
            if (imgFile != null && !imgFile.isEmpty()) {
                imgUrl = saveReviewImage(imgFile, request);
            } else if (removeImg) {
                imgUrl = ""; // 빈 문자열로 DB v_img 비움
            }
            reviewService.updateReview(revIdx, user.getUserIdx(), content, rating, imgUrl);
            return Map.of("success", true);
        } catch (IllegalArgumentException e) {
            return Map.of("success", false, "message", e.getMessage());
        } catch (IOException e) {
            return Map.of("success", false, "message", "이미지 업로드에 실패했습니다.");
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
        // 비로그인 상태에서 user.getRole() 호출 시 NPE 발생 → 다른 메서드와 동일하게 null 체크 추가
        if (user == null) {
            return Map.of("success", false, "message", "로그인이 필요합니다.");
        }
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
