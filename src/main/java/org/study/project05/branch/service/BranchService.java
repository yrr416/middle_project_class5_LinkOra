package org.study.project05.branch.service;

import org.study.project05.branch.vo.BranchVO;
import java.util.List;

public interface BranchService {

    // 검색 결과 리스트 (페이징 포함)
    List<BranchVO> searchWithFilters(
            String keyword, String region, Integer capacity,
            Integer facParking, Integer facHours24, Integer facPet,
            Integer facWifi, Integer facCoffee, Integer facPrinter, Integer facLocker,
            Double lat, Double lng, Integer skip, Integer size
    );

    /**
     * [수정] 전체 개수 가져오기 (이름 통일 및 lat, lng 추가)
     */
    int getCountWithFilters(
            String keyword, String region, Integer capacity,
            Integer facParking, Integer facHours24, Integer facPet,
            Integer facWifi, Integer facCoffee, Integer facPrinter, Integer facLocker,
            Double lat, Double lng // [여기 추가!]
    );

    List<BranchVO> getAllBranches();
}