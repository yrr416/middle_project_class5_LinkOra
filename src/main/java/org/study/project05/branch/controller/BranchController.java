package org.study.project05.branch.controller;

import org.study.project05.branch.service.BranchService;
// 관심 지점 서비스를 사용하기 위해 추가
import org.study.project05.branch.service.WishService;
import org.study.project05.branch.vo.BranchVO;
// 로그인 정보를 확인하기 위해 추가
import org.study.project05.common.util.SessionUtil;
import org.study.project05.mainpage.service.SearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

// 세션을 사용하기 위해 추가
import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/branch")
@RequiredArgsConstructor
public class BranchController {

    private final BranchService branchService;
    private final SearchService searchService;

    // 관심 지점 데이터를 가져오기 위한 서비스 연결
    private final WishService wishService;

    // 관심 지점 화면으로 이동하는 기능 추가
    @GetMapping("/wishlist")
    public String viewWishlist(HttpSession session, Model model) {
        // 로그인한 사용자 번호 가져오기
        Integer userIdx = SessionUtil.getUserIdx(session);

        // 로그인하지 않은 경우 로그인 페이지로 이동
        if (userIdx == null) {
            model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
            model.addAttribute("url", "/loginPage");
            return "common/alert";
        }

        try {
            // 사용자의 관심 지점 목록을 가져와서 화면에 전달
            List<BranchVO> myFavorites = wishService.getMyFavoriteBranches(userIdx);
            model.addAttribute("wishList", myFavorites);
            return "branch/wishlist";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/";
        }
    }

    // 통합된 검색 및 페이징 기능임
    @GetMapping("/search")
    public String search(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) String capacity,
            // 공간 종류(INDIVIDUAL, GROUP 등)를 받기 위해 추가함
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer facParking,
            @RequestParam(required = false) Integer facHours24,
            @RequestParam(required = false) Integer facPet,
            @RequestParam(required = false) Integer facWifi,
            @RequestParam(required = false) Integer facCoffee,
            @RequestParam(required = false) Integer facPrinter,
            @RequestParam(required = false) Integer facLocker,
            @RequestParam(required = false) String lat,
            @RequestParam(required = false) String lng,
            @RequestParam(defaultValue = "1") int page, // 페이지 번호 기본값 1
            Model model) {

        // 1. 데이터 전처리
        String cleanKeyword = null;
        if (keyword != null && !keyword.trim().isEmpty()) {
            cleanKeyword = keyword.replace(",", "").trim();
            if (!cleanKeyword.isEmpty()) {
                searchService.recordKeyword(cleanKeyword);
            }
        }

        Integer intCapacity = (capacity != null && !capacity.isEmpty()) ? Integer.parseInt(capacity) : null;
        Double dblLat = (lat != null && !lat.isEmpty()) ? Double.parseDouble(lat) : null;
        Double dblLng = (lng != null && !lng.isEmpty()) ? Double.parseDouble(lng) : null;

        // 2. 페이징 계산
        int pageSize = 6;
        int skip = (page - 1) * pageSize;

        // 3. 서비스 호출 (리스트 가져오기)
        // type 조건을 서비스로 넘겨줌
        List<BranchVO> list = branchService.searchWithFilters(
                cleanKeyword, region, intCapacity, type,
                facParking, facHours24, facPet, facWifi, facCoffee, facPrinter, facLocker,
                dblLat, dblLng, skip, pageSize
        );

        // 4. [수정 포인트] 전체 개수 가져오기 (메서드명 변경 및 좌표 파라미터 추가)
        // 개수를 셀 때도 type 조건을 넘겨줌
        int totalCount = branchService.getCountWithFilters(
                cleanKeyword, region, intCapacity, type,
                facParking, facHours24, facPet, facWifi, facCoffee, facPrinter, facLocker,
                dblLat, dblLng // lat, lng를 추가로 보내줘야 함!
        );

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // 5. 화면(Model)에 데이터 전달
        model.addAttribute("branches", list);
        model.addAttribute("keyword", cleanKeyword);
        model.addAttribute("region", region);
        model.addAttribute("capacity", intCapacity);
        // 화면에서도 type을 알 수 있게 모델에 담아줌
        model.addAttribute("type", type);
        model.addAttribute("facParking", facParking);
        model.addAttribute("facHours24", facHours24);
        model.addAttribute("facPet", facPet);
        model.addAttribute("facWifi", facWifi);
        model.addAttribute("facCoffee", facCoffee);
        model.addAttribute("facPrinter", facPrinter);
        model.addAttribute("facLocker", facLocker);

        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);

        return "branch/list";
    }

    // 지도 데이터 API
    @GetMapping("/api/data")
    @ResponseBody
    public List<BranchVO> getMapData(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng) {

        String cleanKeyword = null;
        if (keyword != null && !keyword.trim().isEmpty()) {
            cleanKeyword = keyword.replace(",", "").trim();
        }

        // 지도는 페이징 없이 전체를 가져와야 하므로 skip, size는 null로 전달
        // type 자리에는 일단 null을 넣어서 오류를 막음
        return branchService.searchWithFilters(
                cleanKeyword, null, null, null, null, null, null, null, null, null, null, lat, lng, null, null
        );
    }
}