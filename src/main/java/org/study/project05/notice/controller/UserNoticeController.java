package org.study.project05.notice.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.study.project05.notice.service.NoticeService;
import org.study.project05.notice.vo.NoticeVO;

import java.util.List;

/**
 * 일반 사용자용 공지사항 컨트롤러
 * /notice/** 요청 처리 (로그인 불필요, 누구나 접근 가능)
 */
@Slf4j
@Controller
@RequestMapping("/notice")
public class UserNoticeController {

    @Autowired
    private NoticeService noticeService;

    /** 페이지당 공지 표시 수 */
    private static final int NUM_PER_PAGE   = 10;
    /** 페이지 블록당 표시 수 */
    private static final int PAGE_PER_BLOCK = 5;

    /**
     * 공지 목록 페이지 (일반 사용자용)
     * GET /notice/list
     *
     * @param nowPage    현재 페이지 번호 (기본값 1)
     * @param noticeVO   검색어(searchWord) 바인딩용
     * @param model      뷰에 전달할 데이터
     */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int nowPage,
                       NoticeVO noticeVO,
                       Model model) {

        // ── 전체 공지 수 및 페이지 계산 ──────────────────────────────
        int totalRecord = noticeService.getNoticeCount(noticeVO);
        int totalPage   = (totalRecord <= 0) ? 1
                : (int) Math.ceil((double) totalRecord / NUM_PER_PAGE);

        if (nowPage < 1)         nowPage = 1;
        if (nowPage > totalPage) nowPage = totalPage;

        int offset     = (nowPage - 1) * NUM_PER_PAGE;
        // 현재 페이지가 속한 블록의 시작/끝 페이지 번호
        int beginBlock = (int)(Math.floor((double)(nowPage - 1) / PAGE_PER_BLOCK) * PAGE_PER_BLOCK) + 1;
        int endBlock   = Math.min(beginBlock + PAGE_PER_BLOCK - 1, totalPage);

        List<NoticeVO> noticeList = noticeService.getNoticeList(NUM_PER_PAGE, offset, noticeVO);

        model.addAttribute("noticeList",  noticeList);
        model.addAttribute("totalRecord", totalRecord);
        model.addAttribute("totalPage",   totalPage);
        model.addAttribute("nowPage",     nowPage);
        model.addAttribute("beginBlock",  beginBlock);
        model.addAttribute("endBlock",    endBlock);
        model.addAttribute("noticeVO",    noticeVO);   // 검색어 유지용

        return "notice/user_list";
    }

    /**
     * 공지 상세 페이지 (일반 사용자용)
     * GET /notice/detail?ntcIdx=...
     *
     * @param ntcIdx  조회할 공지 PK
     * @param nowPage 목록으로 돌아갈 때 사용할 페이지 번호
     */
    @GetMapping("/detail")
    public String detail(@RequestParam String ntcIdx,
                         @RequestParam(defaultValue = "1") int nowPage,
                         Model model) {

        NoticeVO notice = noticeService.getNoticeDetail(ntcIdx);
        if (notice == null) {
            // 존재하지 않는 공지면 목록으로 리다이렉트
            return "redirect:/notice/list?nowPage=" + nowPage;
        }

        // 이전글 / 다음글 조회 (없으면 null 반환, JSP에서 분기 처리)
        NoticeVO prevNotice = noticeService.getPrevNotice(ntcIdx);
        NoticeVO nextNotice = noticeService.getNextNotice(ntcIdx);

        model.addAttribute("notice",      notice);
        model.addAttribute("prevNotice",  prevNotice);
        model.addAttribute("nextNotice",  nextNotice);
        model.addAttribute("nowPage",     nowPage);

        return "notice/user_detail";
    }
}
