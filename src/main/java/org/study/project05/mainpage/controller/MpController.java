package org.study.project05.mainpage.controller;

import org.study.project05.branch.service.BranchService;
import org.study.project05.mainpage.service.SearchService;
import org.study.project05.branch.vo.BranchVO;
import org.study.project05.mainpage.vo.SearchLogVO;
import org.study.project05.review.mapper.ReviewMapper;
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
    private final ReviewMapper reviewMapper;

    @GetMapping("/")
    public String index(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) Integer capacity,
            Model model) {

        // 1. 인기 검색어 기록
        if (keyword != null && !keyword.trim().isEmpty()) {
            searchService.recordKeyword(keyword);
        }

        // 2. [수정 포인트] 지점 목록 가져오기
        // 파라미터 개수를 14개로 맞춤 (시설필터 7개, 좌표 2개, 페이징 2개 모두 null 처리)
        List<BranchVO> list = branchService.searchWithFilters(
                keyword, region, capacity,
                null, null, null, null, null, null, null, // 시설 필터 7개
                null, null,                               // lat, lng
                null, null                                // skip, size (메인은 전체 혹은 필터만 적용)
        );

        // 3. 인기 검색어 상위 5개 가져오기
        List<SearchLogVO> topTags = searchService.getTopKeywords();

        model.addAttribute("branches", list);
        model.addAttribute("topTags", topTags);
        model.addAttribute("keyword", keyword);
        model.addAttribute("region", region);
        model.addAttribute("recentReviews", reviewMapper.selectRecent(6));

        return "index";
    }
}