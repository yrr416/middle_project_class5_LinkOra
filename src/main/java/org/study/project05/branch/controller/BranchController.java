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
        // [수정] DB 조회 시 유연하게 바꾼 cleanRegion 값을 던져줍니다.
        List<BranchVO> list = branchService.searchWithFilters(
                cleanKeyword, cleanRegion, intCapacity, type,
                facParking, facHours24, facPet, facWifi, facCoffee, facPrinter, facLocker,
                dblLat, dblLng, skip, pageSize
        );

        // 4. 전체 개수 가져오기
        // [수정] 개수 조회 시에도 유연하게 바꾼 cleanRegion 값을 던져줍니다.
        int totalCount = branchService.getCountWithFilters(
                cleanKeyword, cleanRegion, intCapacity, type,
                facParking, facHours24, facPet, facWifi, facCoffee, facPrinter, facLocker,
                dblLat, dblLng
        );

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // DB에서 주소를 읽어와 시/도별로 정리한 목록을 가져옴
        Map<String, List<String>> regionMap = branchService.getRegionMap();
        model.addAttribute("regionMap", regionMap);

        // 5. 화면(Model)에 데이터 전달
        model.addAttribute("branches", list);
        model.addAttribute("keyword", cleanKeyword);

        // [중요] 화면 선택창(select) 유지를 위해 유연하게 바꾼 값이 아닌 원본 region을 그대로 전달함
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

        return branchService.searchWithFilters(
                cleanKeyword, null, null, null, null, null, null, null, null, null, null, lat, lng, null, null
        );
    }
}