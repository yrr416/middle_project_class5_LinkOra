package org.study.project05.notice.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.project05.notice.service.NoticeService;
import org.study.project05.notice.vo.NoticeVO;

import jakarta.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.List;
import java.util.UUID;

/**
 * 공지 관리 컨트롤러
 * /admin/notice/** 요청 처리
 */
@Slf4j
@Controller
@RequestMapping("/admin/notice")
public class NoticeController {

    @Autowired
    private NoticeService noticeService;

    /** 페이지당 공지 표시 수 */
    private static final int NUM_PER_PAGE   = 10;
    /** 페이지 블록당 표시 수 */
    private static final int PAGE_PER_BLOCK = 5;

    /**
     * 공지 목록 페이지
     * GET /admin/notice/list
     */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int nowPage,
                       NoticeVO noticeVO,
                       Model model) {

        int totalRecord = noticeService.getNoticeCount(noticeVO);
        int totalPage   = (totalRecord <= 0) ? 1
                : (int) Math.ceil((double) totalRecord / NUM_PER_PAGE);

        if (nowPage < 1) nowPage = 1;
        if (nowPage > totalPage) nowPage = totalPage;

        int offset     = (nowPage - 1) * NUM_PER_PAGE;
        int beginBlock = (int)(Math.floor((double)(nowPage - 1) / PAGE_PER_BLOCK) * PAGE_PER_BLOCK) + 1;
        int endBlock   = Math.min(beginBlock + PAGE_PER_BLOCK - 1, totalPage);

        List<NoticeVO> noticeList = noticeService.getNoticeList(NUM_PER_PAGE, offset, noticeVO);

        model.addAttribute("noticeList",   noticeList);
        model.addAttribute("totalRecord",  totalRecord);
        model.addAttribute("totalPage",    totalPage);
        model.addAttribute("nowPage",      nowPage);
        model.addAttribute("beginBlock",   beginBlock);
        model.addAttribute("endBlock",     endBlock);
        model.addAttribute("noticeVO",     noticeVO);

        return "notice/list";
    }

    /**
     * 공지 등록 폼 (새 공지)
     * GET /admin/notice/register
     */
    @GetMapping("/register")
    public String registerForm() {
        return "notice/form";
    }

    /**
     * 공지 수정 폼 (기존 공지 불러오기)
     * GET /admin/notice/update?nIdx=...
     */
    @GetMapping("/update")
    public String updateForm(@RequestParam String ntcIdx,
                             @RequestParam(defaultValue = "1") int nowPage,
                             Model model) {

        NoticeVO notice = noticeService.getNoticeDetail(ntcIdx);
        if (notice == null) {
            return "redirect:/admin/notice/list";
        }

        model.addAttribute("notice",  notice);
        model.addAttribute("nowPage", nowPage);

        return "notice/form";
    }

    /**
     * 공지 등록 처리 (즉시 발행 / 예약 발행)
     * POST /admin/notice/registerok
     */
    @PostMapping("/registerok")
    public String registerOk(NoticeVO noticeVO,
                             @RequestParam(defaultValue = "1") int nowPage,
                             RedirectAttributes rttr) {

        // admIdx = 1 (관리자 고정값; 실제 세션에서 가져올 경우 교체)
        noticeVO.setAdmIdx("1");

        int result = noticeService.insertNotice(noticeVO);
        log.info("공지 등록 - 제목: {}, 결과: {}", noticeVO.getNtcTitle(), result);

        rttr.addFlashAttribute("msg", "공지가 등록되었습니다.");
        return "redirect:/admin/notice/list?nowPage=" + nowPage;
    }

    /**
     * 공지 수정 처리
     * POST /admin/notice/updateok
     */
    @PostMapping("/updateok")
    public String updateOk(NoticeVO noticeVO,
                           @RequestParam(defaultValue = "1") int nowPage,
                           RedirectAttributes rttr) {

        int result = noticeService.updateNotice(noticeVO);
        log.info("공지 수정 - ntcIdx: {}, 결과: {}", noticeVO.getNtcIdx(), result);

        rttr.addFlashAttribute("msg", "공지가 수정되었습니다.");
        return "redirect:/admin/notice/list?nowPage=" + nowPage;
    }

    /**
     * 고정 여부 토글 (고정 ↔ 일반)
     * POST /admin/notice/toggle
     */
    @PostMapping("/toggle")
    public String toggle(@RequestParam String ntcIdx,
                         @RequestParam(defaultValue = "1") int nowPage,
                         NoticeVO noticeVO) {

        noticeService.toggleNoticeActive(ntcIdx);
        log.info("공지 고정 토글 - ntcIdx: {}", ntcIdx);

        return buildRedirect(nowPage, noticeVO);
    }

    /**
     * 공지 삭제
     * POST /admin/notice/delete
     */
    @PostMapping("/delete")
    public String delete(@RequestParam String ntcIdx,
                         @RequestParam(defaultValue = "1") int nowPage,
                         RedirectAttributes rttr) {

        noticeService.deleteNotice(ntcIdx);
        log.info("공지 삭제 - ntcIdx: {}", ntcIdx);

        rttr.addFlashAttribute("msg", "공지가 삭제되었습니다.");
        return "redirect:/admin/notice/list?nowPage=" + nowPage;
    }

    /**
     * 에디터 이미지 업로드 (CKEditor 5 응답 형식)
     * POST /admin/notice/imageUpload
     */
    @PostMapping("/imageUpload")
    @ResponseBody
    public String imageUpload(@RequestParam("upload") MultipartFile file,
                              HttpServletRequest request) {
        try {
            String uploadPath = request.getServletContext().getRealPath("/static/img/notice");
            File dir = new File(uploadPath);
            if (!dir.exists()) dir.mkdirs();

            String ext      = file.getOriginalFilename().substring(
                                file.getOriginalFilename().lastIndexOf("."));
            String fileName = UUID.randomUUID().toString() + ext;
            file.transferTo(new File(dir, fileName));

            String url = request.getContextPath() + "/static/img/notice/" + fileName;
            return "{\"url\":\"" + url + "\"}";

        } catch (Exception e) {
            log.error("이미지 업로드 실패", e);
            return "{\"error\":{\"message\":\"업로드 실패\"}}";
        }
    }

    /**
     * 목록 리다이렉트 URL 생성 (필터 파라미터 유지)
     */
    private String buildRedirect(int nowPage, NoticeVO noticeVO) {
        StringBuilder sb = new StringBuilder("redirect:/admin/notice/list?nowPage=").append(nowPage);
        if (noticeVO.getSearchWord() != null && !noticeVO.getSearchWord().isEmpty()) {
            sb.append("&searchWord=").append(noticeVO.getSearchWord());
        }
        if (noticeVO.getActiveFilter() != null && !noticeVO.getActiveFilter().isEmpty()) {
            sb.append("&activeFilter=").append(noticeVO.getActiveFilter());
        }
        return sb.toString();
    }
}
