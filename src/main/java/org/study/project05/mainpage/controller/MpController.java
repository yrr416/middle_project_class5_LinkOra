package org.study.project05.mainpage.controller;

import org.study.project05.branch.service.BranchService;
import org.study.project05.mainpage.service.SearchService;
import org.study.project05.branch.vo.BranchVO;
import org.study.project05.mainpage.vo.SearchLogVO;
import org.study.project05.review.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class MpController {

    private final BranchService branchService;
    private final SearchService searchService;
    private final ReviewService reviewService;

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

        // 2. [수정 포인트] 지점 목록 가져오기
        // 서비스 인터페이스 변경에 맞춰 파라미터를 15개로 조정함
        List<BranchVO> list = branchService.searchWithFilters(
                keyword, region, capacity,
                type,                                     // 추가된 type 파라미터 전달
                null, null, null, null, null, null, null, // 시설 필터 7개
                null, null,                               // lat, lng
                null, null                                // skip, size
        );

        // 3. 인기 검색어 상위 5개 가져오기
        List<SearchLogVO> topTags = searchService.getTopKeywords();

        model.addAttribute("branches", list);
        model.addAttribute("topTags", topTags);
        model.addAttribute("keyword", keyword);
        model.addAttribute("region", region);
        // 화면에서도 type을 사용할 수 있도록 추가함
        model.addAttribute("type", type);
        model.addAttribute("recentReviews", reviewService.getRecentReviews(6));

        return "index";
    }
}