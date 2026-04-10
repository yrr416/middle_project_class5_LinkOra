package org.study.project05.mainpage.controller;

import org.study.project05.branch.service.BranchService;
import org.study.project05.mainpage.service.SearchService;
import org.study.project05.branch.vo.BranchVO;
import org.study.project05.mainpage.vo.SearchLogVO;
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

    @GetMapping("/")
    public String index(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) Integer capacity,
            Model model) {

        // [수정] XML의 id인 recordKeyword에 맞춰서 호출함
        if (keyword != null && !keyword.trim().isEmpty()) {
            searchService.recordKeyword(keyword);
        }

        // 지점 목록 가져오기 (기존 유지)
        List<BranchVO> list = branchService.searchWithFilters(
                keyword, region, capacity, null, null, null,
                null, null, null, null, null, null
        );

        // 인기 검색어 상위 5개 가져오기
        List<SearchLogVO> topTags = searchService.getTopKeywords();

        model.addAttribute("branches", list);
        model.addAttribute("topTags", topTags);
        model.addAttribute("keyword", keyword);
        model.addAttribute("region", region);

        return "index";
    }
}