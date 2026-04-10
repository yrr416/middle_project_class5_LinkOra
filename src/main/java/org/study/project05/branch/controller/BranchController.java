package org.study.project05.branch.controller;

import org.study.project05.branch.service.BranchService;
import org.study.project05.branch.vo.BranchVO;
import org.study.project05.mainpage.service.SearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody; // [추가] JSON 데이터 전송용 임포트

import java.util.List;

/**
 * 지점 검색과 관련된 요청을 처리하는 안내원임.
 */
@Controller
@RequestMapping("/branch")
@RequiredArgsConstructor
public class BranchController {

    private final BranchService branchService;
    private final SearchService searchService;

    /**
     * 사용자가 검색창을 이용할 때 실행되는 기능임.
     */
    @GetMapping("/search")
    public String search(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) Integer capacity,
            @RequestParam(required = false) Integer facParking, // parking -> facParking 으로 변경함.
            @RequestParam(required = false) Integer facH24,     // h24 -> facH24 로 변경함.
            @RequestParam(required = false) Integer facPet,     // pet -> facPet 으로 변경함.
            @RequestParam(required = false) Integer facWifi,    // wifi -> facWifi 로 변경함.
            @RequestParam(required = false) Integer facCoffee,  // coffee -> facCoffee 로 변경함.
            @RequestParam(required = false) Integer facPrinter, // printer -> facPrinter 로 변경함.
            @RequestParam(required = false) Integer facLocker,  // locker -> facLocker 로 변경함.
            @RequestParam(required = false) Double lat,         // [추가] 내 위치 위도(GPS)를 받음!
            @RequestParam(required = false) Double lng,         // [추가] 내 위치 경도(GPS)를 받음!
            Model model) {

        // 쉼표(,) 제거 로직임 (기존 로직 그대로 유지함).
        String cleanKeyword = null;
        if (keyword != null && !keyword.trim().isEmpty()) {
            cleanKeyword = keyword.replace(",", "").trim();
            if (!cleanKeyword.isEmpty()) {
                searchService.recordKeyword(cleanKeyword);
            }
        }

        /**
         * [오류 수정] 서비스의 searchWithFilters 매개변수가 10개에서 12개로 늘어났음!
         * 위도(lat)와 경도(lng)를 마지막에 추가해서 배달함.
         */
        List<BranchVO> list = branchService.searchWithFilters(
                cleanKeyword, region, capacity,
                facParking, facH24, facPet, facWifi, facCoffee, facPrinter, facLocker,
                lat, lng // [추가] 좌표 데이터를 서비스로 넘겨줌!
        );

        // JSP 화면에서 체크박스 상태를 유지하기 위해 모델에 담아줌.
        model.addAttribute("branches", list);
        model.addAttribute("keyword", cleanKeyword);
        model.addAttribute("region", region);
        model.addAttribute("capacity", capacity);
        model.addAttribute("facParking", facParking); // 화면에서도 바뀐 이름을 쓰도록 보냄.
        model.addAttribute("facH24", facH24);
        model.addAttribute("facPet", facPet);
        model.addAttribute("facWifi", facWifi);
        model.addAttribute("facCoffee", facCoffee);
        model.addAttribute("facPrinter", facPrinter);
        model.addAttribute("facLocker", facLocker);

        // [추가] 결과 화면에서도 현재 위치를 기억할 수 있게 담아줌.
        model.addAttribute("lat", lat);
        model.addAttribute("lng", lng);

        return "branch/list";
    }

    /**
     * ==========================================
     * [강제 해결] 지도의 핀 데이터를 위해 JSON을 직접 쏴주는 통로임!
     * mp_script.js가 /branch/api/data 로 요청하면 여기서 데이터를 꺼내줍니다.
     * ==========================================
     */
    @GetMapping("/api/data")
    @ResponseBody // JSP(화면)로 가지 않고, 데이터(JSON)만 스크립트에게 바로 던져줌
    public List<BranchVO> getMapData(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng) {

        String cleanKeyword = null;
        if (keyword != null && !keyword.trim().isEmpty()) {
            cleanKeyword = keyword.replace(",", "").trim();
        }

        // 지도 핀을 꽂을 때는 상세 필터(주차장, 24시간 등)가 필요 없으므로 null로 채우고,
        // GPS 좌표(lat, lng)만 서비스로 던져서 주변 지점을 가져옴
        return branchService.searchWithFilters(
                cleanKeyword, null, null, null, null, null, null, null, null, null, lat, lng
        );
    }
}