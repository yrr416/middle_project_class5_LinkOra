package org.study.project05.map.controller;

import org.study.project05.branch.vo.BranchVO;
import org.study.project05.map.service.MapService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import java.util.List;

/**
 * 지도와 관련된 요청을 받아서 처리하는 안내원 역할임.
 */
@Controller
// @RequestMapping("/linkora") // [박사 처방] 주소 꼬임을 방지하기 위해 주석 처리함.
@RequiredArgsConstructor // [기능] 서비스(요리사)를 자동으로 불러와서 연결해줌.
public class MapController {

    // [중요] 지도 서비스 기능을 쓰기 위해 가져옴.
    private final MapService mapService;

    // [기능] 웹 브라우저에 지도 화면(map.jsp)을 보여주는 문임.
    // 주소창에 localhost:8080/map (또는 설정에 따라 /linkora/map)을 치면 나옴.
    @GetMapping("/map")
    public String mapPage() {
        return "map/map"; // [결과] views/map/map.jsp 파일을 화면에 띄움.
    }

    // [기능] 지도 화면 안에 있는 지점들을 가져오는 문임.
    // [에러 해결] BranchRestController와 주소가 겹쳐서 /api/map-branches로 변경함.
    @GetMapping("/api/map-branches")
    @ResponseBody // [설명] 페이지 이동이 아니라 데이터(JSON)만 보내줌.
    public List<BranchVO> getMapBranches(
            @RequestParam(value = "swLat", required = false) Double swLat, // 남서쪽 위도임.
            @RequestParam(value = "swLng", required = false) Double swLng, // 남서쪽 경도임.
            @RequestParam(value = "neLat", required = false) Double neLat, // 북동쪽 위도임.
            @RequestParam(value = "neLng", required = false) Double neLng) { // 북동쪽 경도임.

        // [판단] 지도 영역 좌표가 없으면 전체 리스트를 주고, 있으면 영역 안의 것만 가져옴.
        if (swLat == null) return mapService.getBranchList();
        return mapService.getBranchesInMap(swLat, swLng, neLat, neLng);
    }

    // ==========================================
    // GPS 기반 주변 지점 검색 문임.
    // ==========================================
    // [기능] 사용자의 현재 위도와 경도를 받아서 주변 지점을 찾아줌.
    @GetMapping("/api/branches/nearby")
    @ResponseBody
    public List<BranchVO> getNearbyBranches(
            @RequestParam("lat") Double lat, // 사용자의 현재 위도임.
            @RequestParam("lng") Double lng) { // 사용자의 현재 경도임.

        // [작동] Service한테 내 위치를 알려주고 주변 지점을 가져오라고 시킴.
        // 결과는 바뀐 규칙(brnIdx 등)이 적용된 BranchVO 리스트로 나감.
        return mapService.getNearbyBranches(lat, lng);
    }
} 
