package org.study.project05.notice.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.study.project05.notice.service.NoticeService;
import org.study.project05.notice.vo.NoticeVO;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import java.io.File;
import java.nio.file.Paths;
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

    /** application.properties의 app.upload.notice-dir 값 (기본: uploads/notice) */
    @Value("${app.upload.notice-dir:uploads/notice}")
    private String noticeUploadDir;

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
     * 공지/이벤트 등록 폼 (새 공지)
     * GET /admin/notice/register?type=notice|event
     *
     * @param type "notice"(공지, ntcActive=0) 또는 "event"(이벤트, ntcActive=1)
     */
    @GetMapping("/register")
    public String registerForm(@RequestParam(defaultValue = "notice") String type,
                               Model model) {
        model.addAttribute("type", type);
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
     * 공지 등록 처리
     * POST /admin/notice/registerok
     * enctype="multipart/form-data" 로 전송됨
     */
    @PostMapping("/registerok")
    public String registerOk(NoticeVO noticeVO,
                             @RequestParam(defaultValue = "1") int nowPage,
                             @RequestParam(value = "ntcImgFile", required = false) MultipartFile ntcImgFile,
                             HttpServletRequest request,
                             RedirectAttributes rttr) {

        noticeVO.setAdmIdx("1");

        // 이미지 파일이 첨부된 경우 서버에 저장 후 URL을 VO에 세팅
        if (ntcImgFile != null && !ntcImgFile.isEmpty()) {
            String imgUrl = saveNoticeImage(ntcImgFile, request);
            if (imgUrl != null) noticeVO.setNtcImg(imgUrl);
        }

        int result = noticeService.insertNotice(noticeVO);
        log.info("공지 등록 - 제목: {}, 이미지: {}, 결과: {}", noticeVO.getNtcTitle(), noticeVO.getNtcImg(), result);

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
                           @RequestParam(value = "ntcImgFile", required = false) MultipartFile ntcImgFile,
                           HttpServletRequest request,
                           RedirectAttributes rttr) {

        // 새 이미지가 첨부된 경우에만 교체 (없으면 기존 이미지 유지)
        if (ntcImgFile != null && !ntcImgFile.isEmpty()) {
            String imgUrl = saveNoticeImage(ntcImgFile, request);
            if (imgUrl != null) noticeVO.setNtcImg(imgUrl);
        }

        int result = noticeService.updateNotice(noticeVO);
        log.info("공지 수정 - ntcIdx: {}, 이미지: {}, 결과: {}", noticeVO.getNtcIdx(), noticeVO.getNtcImg(), result);

        rttr.addFlashAttribute("msg", "공지가 수정되었습니다.");
        return "redirect:/admin/notice/list?nowPage=" + nowPage;
    }

    /**
     * 공지/이벤트 대표 이미지를 서버에 저장하고 접근 URL을 반환하는 공통 메서드
     *
     * @param file    업로드된 이미지 파일
     * @param request HTTP 요청 (저장 경로 및 context path 추출용)
     * @return 브라우저에서 접근 가능한 이미지 URL, 실패 시 null
     */
    private String saveNoticeImage(MultipartFile file, HttpServletRequest request) {
        try {
            // application.properties의 app.upload.notice-dir 경로를 절대 경로로 변환
            File dir = Paths.get(noticeUploadDir).toAbsolutePath().normalize().toFile();
            if (!dir.exists()) dir.mkdirs();

            String original = file.getOriginalFilename();
            String ext      = original.substring(original.lastIndexOf("."));
            String fileName = UUID.randomUUID().toString() + ext;
            file.transferTo(new File(dir, fileName));

            // WebMvcConfig에 등록된 /uploads/notice/** 핸들러로 서빙
            return request.getContextPath() + "/uploads/notice/" + fileName;
        } catch (Exception e) {
            log.error("공지 이미지 저장 실패", e);
            return null;
        }
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
     * 에디터 이미지 업로드 (CKEditor 5 SimpleUploadAdapter 응답 형식)
     * POST /admin/notice/imageUpload
     *
     * CKEditor 5는 응답 Content-Type이 반드시 application/json 이어야
     * 파싱 후 이미지를 에디터에 삽입함.
     * (text/plain 반환 시 CKEditor가 JSON 파싱을 건너뛰어 삽입이 안 됨)
     */
    @PostMapping("/imageUpload")
    public ResponseEntity<String> imageUpload(@RequestParam("upload") MultipartFile file,
                                              HttpServletRequest request) {
        try {
            // 1) app.upload.notice-dir 절대 경로로 저장
            File dir = Paths.get(noticeUploadDir).toAbsolutePath().normalize().toFile();
            if (!dir.exists()) dir.mkdirs();

            // 2) 파일 저장
            String originalName = file.getOriginalFilename();
            String ext      = originalName.substring(originalName.lastIndexOf("."));
            String fileName = UUID.randomUUID().toString() + ext;
            file.transferTo(new File(dir, fileName));

            // 3) 브라우저에서 접근 가능한 URL 반환 (WebMvcConfig의 /uploads/notice/** 핸들러 사용)
            String url = request.getContextPath() + "/uploads/notice/" + fileName;
            log.info("이미지 업로드 성공 - 저장경로: {}, URL: {}", dir + "/" + fileName, url);

            // Content-Type: application/json 으로 반환해야 CKEditor가 삽입 처리
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body("{\"url\":\"" + url + "\"}");

        } catch (Exception e) {
            log.error("이미지 업로드 실패", e);
            return ResponseEntity.internalServerError()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body("{\"error\":{\"message\":\"이미지 업로드에 실패했습니다.\"}}");
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
