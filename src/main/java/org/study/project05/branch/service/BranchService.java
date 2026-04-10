package org.study.project05.branch.service;

import org.study.project05.branch.vo.BranchVO;
import java.util.List;

/**
 * 지점 관련 비즈니스 로직을 정의하는 인터페이스임.
 */
public interface BranchService {

    /**
     * [기존 필터 + GPS 검색] 여러 조건(필터)을 사용해서 지점을 찾는 기능임.
     * * @param lat 내 위치 위도 (GPS) - 주변 지점 검색 시 사용됨.
     * @param lng 내 위치 경도 (GPS) - 주변 지점 검색 시 사용됨.
     * 매개변수 이름을 VO 및 Mapper와 맞춰서 12개로 확장함.
     */
    List<BranchVO> searchWithFilters(
            String keyword,
            String region,
            Integer capacity,
            Integer facParking,
            Integer facH24,
            Integer facPet,
            Integer facWifi,
            Integer facCoffee,
            Integer facPrinter,
            Integer facLocker,
            Double lat, // [추가] 내 위치 위도
            Double lng  // [추가] 내 위치 경도
    );

    /**
     * [지도] 지도에 핀을 꽂기 위해 모든 지점 정보를 가져오는 기능임.
     */
    List<BranchVO> getAllBranches();
}