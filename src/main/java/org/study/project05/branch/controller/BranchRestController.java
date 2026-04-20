package org.study.project05.branch.controller;

import org.study.project05.branch.service.BranchService;
import org.study.project05.branch.vo.BranchVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 지점 데이터를 JSON 형식으로 바로 쏴주는 리액트/데이터 전용 안내원임.
 */
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class BranchRestController {

    private final BranchService branchService;

    // 지도에 핀을 꽂기 위해 모든 지점의 정보를 가져오는 기능임.
    @GetMapping("/all-branches")
    public List<BranchVO> getAllBranches() {
        return branchService.getAllBranches();
    }

    /**
     * [수정] 지도가 로딩되거나 검색할 때 사용하는 API.
     * 서비스 인터페이스가 변경됨에 따라 파라미터 개수를 맞춰줌.
     */
    @GetMapping("/branches")
    public List<BranchVO> getBranches(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) Integer capacity,
            // [추가] 공간 종류(type) 파라미터를 새로 추가함
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer facParking,
            @RequestParam(required = false) Integer facHours24,
            @RequestParam(required = false) Integer facPet,
            @RequestParam(required = false) Integer facWifi,
            @RequestParam(required = false) Integer facCoffee,
            @RequestParam(required = false) Integer facPrinter,
            @RequestParam(required = false) Integer facLocker,
            // 새로 만든 4가지 편의시설 데이터도 화면에서 받을 수 있게 바구니를 준비해요!
            @RequestParam(required = false) Integer facCafe,
            @RequestParam(required = false) Integer facKitchen,
            @RequestParam(required = false) Integer facWater,
            @RequestParam(required = false) Integer facLounge,
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng
    ) {
        // [중요] 서비스의 searchWithFilters 호출 시 type을 포함하여 파라미터를 전달함.
        return branchService.searchWithFilters(
                keyword, region, capacity,
                type, // 새로 만든 type 구멍에 맞춰서 값을 넣어줌
                facParking, facHours24, facPet, facWifi, facCoffee, facPrinter, facLocker,
                // 화면에서 받은 4가지 편의시설 데이터를 서비스 파일로 똑같이 던져줘요!
                facCafe, facKitchen, facWater, facLounge,
                lat, lng,
                null, null // skip, size는 null로 전달 (LIMIT 무시)
        );
    }
}