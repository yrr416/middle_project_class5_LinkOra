package org.study.project05.branch.controller;

import org.study.project05.branch.service.BranchService;
import org.study.project05.branch.service.WishService;
import org.study.project05.branch.vo.BranchVO;

import org.study.project05.common.util.SessionUtil;
import org.study.project05.mainpage.service.SearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/branch")
@RequiredArgsConstructor
public class BranchController {

    private final BranchService branchService;
    private final SearchService searchService;
    private final WishService wishService;

    // 관심 지점 화면으로 이동하는 기능
    @GetMapping("/wishlist")
    public String viewWishlist(HttpSession session, Model model) {
        Integer userIdx = SessionUtil.getUserIdx(session);

        if (userIdx == null) {
            model.addAttribute("msg", "로그인이 필요한 서비스입니다.");
            model.addAttribute("url", "/loginPage");
            return "common/alert";
        }

        try {
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
            @RequestParam(required = false) String type,

            @RequestParam(required = false) Integer facParking,
            @RequestParam(required = false) Integer facHours24,
            @RequestParam(required = false) Integer facPet,
            @RequestParam(required = false) Integer facWifi,
            @RequestParam(required = false) Integer facCoffee,
            @RequestParam(required = false) Integer facPrinter,
            @RequestParam(required = false) Integer facLocker,
            // [추가] 신규 시설 필터 4종
            @RequestParam(required = false) Integer facCafe,
            @RequestParam(required = false) Integer facKitchen,
            @RequestParam(required = false) Integer facWater,
            @RequestParam(required = false) Integer facLounge,
            @RequestParam(required = false) String lat,
            @RequestParam(required = false) String lng,
            @RequestParam(defaultValue = "1") int page,
            Model model) {

        // 1. 데이터 전처리
        String cleanKeyword = null;
        if (keyword != null && !keyword.trim().isEmpty()) {
            cleanKeyword = keyword.replace(",", "").trim();
            if (!cleanKeyword.isEmpty()) {
                searchService.recordKeyword(cleanKeyword);
            }
        }

        // [핵심 추가] DB의 다양한 서울 표기("서울 특별시", "서울시")를 모두 찾을 수 있도록 유연하게 변경
        String cleanRegion = null;
        if (region != null && !region.trim().isEmpty()) {
            cleanRegion = region.trim();
            if (cleanRegion.startsWith("서울특별시")) {
                cleanRegion = cleanRegion.replaceFirst("서울특별시", "서울");
            }
            // "서울 강남구" -> "서울%강남구" 로 변환하여 DB 검색 시 띄어쓰기를 유연하게 허용함
            cleanRegion = cleanRegion.replace(" ", "%");
        }

        Integer intCapacity = (capacity != null && !capacity.isEmpty()) ? Integer.parseInt(capacity) : null;
        Double dblLat = (lat != null && !lat.isEmpty()) ? Double.parseDouble(lat) : null;
        Double dblLng = (lng != null && !lng.isEmpty()) ? Double.parseDouble(lng) : null;

        // 2. 페이징 계산
        int pageSize = 6;
        int skip = (page - 1) * pageSize;

        // 3. 서비스 호출 (리스트 가져오기)
        // [수정] 신규 필터 4개를 포함하여 19개 파라미터 전달
        List<BranchVO> list = branchService.searchWithFilters(
                cleanKeyword, cleanRegion, intCapacity, type,
                facParking, facHours24, facPet, facWifi, facCoffee, facPrinter, facLocker,
                facCafe, facKitchen, facWater, facLounge,
                dblLat, dblLng, skip, pageSize
        );

        // 4. 전체 개수 가져오기
        // [수정] 개수 조회 시에도 모든 필터 전달
        int totalCount = branchService.getCountWithFilters(
                cleanKeyword, cleanRegion, intCapacity, type,
                facParking, facHours24, facPet, facWifi, facCoffee, facPrinter, facLocker,
                facCafe, facKitchen, facWater, facLounge,
                dblLat, dblLng
        );

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // DB에서 주소를 읽어와 시/도별로 정리한 목록을 가져옴
        Map<String, List<String>> regionMap = branchService.getRegionMap();
        model.addAttribute("regionMap", regionMap);

        // 5. 화면(Model)에 데이터 전달 (UI 체크박스 상태 유지를 위함)
        model.addAttribute("branches", list);
        model.addAttribute("keyword", cleanKeyword);
        model.addAttribute("region", region);
        model.addAttribute("capacity", intCapacity);
        model.addAttribute("type", type);
        model.addAttribute("facParking", facParking);
        model.addAttribute("facHours24", facHours24);
        model.addAttribute("facPet", facPet);
        model.addAttribute("facWifi", facWifi);
        model.addAttribute("facCoffee", facCoffee);
        model.addAttribute("facPrinter", facPrinter);
        model.addAttribute("facLocker", facLocker);
        model.addAttribute("facCafe", facCafe);
        model.addAttribute("facKitchen", facKitchen);
        model.addAttribute("facWater", facWater);
        model.addAttribute("facLounge", facLounge);

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
        // 파라미터가 19개로 늘어났으므로 규격에 맞춰 null을 추가로 던져줌
        return branchService.searchWithFilters(
                cleanKeyword, null, null, null,
                null, null, null, null, null, null, null,
                null, null, null, null, // 신규 시설 4종 null
                lat, lng, null, null
        );
    }
}