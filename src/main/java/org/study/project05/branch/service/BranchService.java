package org.study.project05.branch.service;

import org.study.project05.branch.vo.BranchVO;
import java.util.List;
import java.util.Map; // Map 사용을 위한 import 추가

public interface BranchService {

    // 검색 결과 리스트 (페이징 포함)
    // 컨트롤러에서 넘겨주는 공간 종류(type)를 받기 위해 String type 추가
    List<BranchVO> searchWithFilters(
            String keyword, String region, Integer capacity,
            String type,
            Integer facParking, Integer facHours24, Integer facPet,
            Integer facWifi, Integer facCoffee, Integer facPrinter, Integer facLocker,
            // 새롭게 추가된 편의시설 정보를 전달받기 위한 파라미터 추가
            Integer facCafe, Integer facKitchen, Integer facWater, Integer facLounge,
            Double lat, Double lng, Integer skip, Integer size
    );

    /**
     * [수정] 전체 개수 가져오기 (이름 통일 및 lat, lng 추가)
     */
    // 개수를 셀 때도 공간 종류(type)를 받기 위해 String type 추가
    int getCountWithFilters(
            String keyword, String region, Integer capacity,
            String type,
            Integer facParking, Integer facHours24, Integer facPet,
            Integer facWifi, Integer facCoffee, Integer facPrinter, Integer facLocker,
            // 전체 개수를 셀 때도 새로운 편의시설 조건을 반영하기 위해 파라미터 추가
            Integer facCafe, Integer facKitchen, Integer facWater, Integer facLounge,
            Double lat, Double lng // [여기 추가!]
    );

    List<BranchVO> getAllBranches();

    // 지역 목록(시/도 및 구/군)을 가져오는 메서드 추가
    Map<String, List<String>> getRegionMap();
}