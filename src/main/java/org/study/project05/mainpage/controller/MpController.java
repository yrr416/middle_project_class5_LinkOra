package org.study.project05.mainpage.controller;

import org.study.project05.branch.service.BranchService;
import org.study.project05.mainpage.service.SearchService;
import org.study.project05.branch.vo.BranchVO;
import org.study.project05.mainpage.vo.SearchLogVO;
import org.study.project05.notice.service.NoticeService;
import org.study.project05.notice.vo.NoticeVO;
import org.study.project05.review.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map; // 지역 상자(Map)를 쓰기 위해 꼭 추가해야 해요!

@Controller
@RequiredArgsConstructor
public class MpController {

    private final BranchService branchService;
    private final SearchService searchService;
    private final ReviewService reviewService;
    private final NoticeService noticeService;

    @GetMapping("/")
    public String index(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) Integer capacity,
            // 공간 종류(type) 파라미터를 추가함
            @RequestParam(required = false) String type,
            Model model) {

        // 1. 인기 검색어 기록
        if (keyword != null && !keyword.trim().isEmpty()) {
            searchService.recordKeyword(keyword);
        }

        // 2. 지점 목록 가져오기
        // [수정] 서비스 설계도 변경에 맞춰 빈칸을 19개로 맞춰줬어요!
        List<BranchVO> list = branchService.searchWithFilters(
                keyword, region, capacity,
                type,                                     // 추가된 type 파라미터 전달
                null, null, null, null, null, null, null, // 기존 편의시설 빈칸 7개
                null, null, null, null,                   // [여기 추가!] 새로 만든 편의시설(카페, 주방, 정수기, 라운지)을 위한 빈칸 4개
                null, null,                               // lat, lng
                null, null                                // skip, size
        );

        // 3. 인기 검색어 상위 5개 가져오기
        List<SearchLogVO> topTags = searchService.getTopKeywords();

        // 4. 최신 공지/이벤트 5개 (고정 우선, 최신순) - 주요소식 섹션용
        List<NoticeVO> noticeList = noticeService.getNoticeList(5, 0, new NoticeVO());

        // 5. 이벤트만 최대 5개 - 슬라이드 배너용 (n_active % 2 == 1)
        NoticeVO eventFilter = new NoticeVO();
        eventFilter.setActiveFilter("1"); // 이벤트 필터 (MOD(n_active,2)=1)
        List<NoticeVO> eventList = noticeService.getNoticeList(5, 0, eventFilter);

        // 메인 페이지에서도 지역 정보 상자를 만들어서 화면으로 전달해요!
        Map<String, List<String>> regionMap = branchService.getRegionMap();
        model.addAttribute("regionMap", regionMap);

        model.addAttribute("branches", list);
        model.addAttribute("topTags", topTags);
        model.addAttribute("keyword", keyword);
        model.addAttribute("region", region);
        // 화면에서도 type을 사용할 수 있도록 추가함
        model.addAttribute("type", type);
        model.addAttribute("recentReviews", reviewService.getRecentReviews(6));
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("eventList", eventList);

        return "index";
    }
}