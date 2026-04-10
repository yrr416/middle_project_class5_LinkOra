package org.study.project05.branch.controller;

import org.study.project05.branch.service.BranchService;
import org.study.project05.branch.vo.BranchVO;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping; // GetMapping 임포트 추가함.
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam; // RequestParam 추가함.
import org.springframework.web.bind.annotation.RestController;

import java.util.List; // List 임포트 추가함.

/**
 * 지점 데이터를 JSON 형식으로 바로 쏴주는 리액트/데이터 전용 안내원임.
 */
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class BranchRestController {

    private final BranchService branchService;

    // [충돌 해결] 주소를 /all-branches로 변경함.
    // 지도에 핀을 꽂기 위해 모든 지점의 좌표 정보를 가져오는 기능임.
    @GetMapping("/all-branches")
    public List<BranchVO> getAllBranches() {
        // DB에서 좌표를 포함한 전 지점 데이터를 가져와서 웹 브라우저에 전달함.
        // 결과는 우리가 수정한 BranchVO 리스트 형태로 나감.
        return branchService.getAllBranches();
    }

    /**
     * [추가] 지도가 로딩되거나 검색할 때, 현재 위치(GPS) 기반으로 데이터를 가져오는 기능임.
     * mp_script.js의 loadBranches 함수가 호출하는 주소(/api/branches)와 연결됨.
     */
    @GetMapping("/branches")
    public List<BranchVO> getBranches(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String region,
            @RequestParam(required = false) Integer capacity,
            @RequestParam(required = false) Integer facParking,
            @RequestParam(required = false) Integer facH24,
            @RequestParam(required = false) Integer facPet,
            @RequestParam(required = false) Integer facWifi,
            @RequestParam(required = false) Integer facCoffee,
            @RequestParam(required = false) Integer facPrinter,
            @RequestParam(required = false) Integer facLocker,
            @RequestParam(required = false) Double lat, // [중요] JS가 보낸 내 위치 위도
            @RequestParam(required = false) Double lng  // [중요] JS가 보낸 내 위치 경도
    ) {
        // 서비스에 12개의 재료(검색어, 지역, 인원, 시설필터 7개, 좌표 2개)를 담아 검색을 요청함.
        // Mapper XML에서 이 lat, lng를 받아 반경 내 지점을 계산하여 반환함.
        return branchService.searchWithFilters(
                keyword, region, capacity,
                facParking, facH24, facPet, facWifi, facCoffee, facPrinter, facLocker,
                lat, lng
        );
    }
}