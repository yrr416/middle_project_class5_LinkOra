package org.study.project05.branch.service;

import org.study.project05.branch.vo.BranchVO;
import org.study.project05.branch.mapper.BranchMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 지점 검색 및 조회를 실제로 수행하는 구현체임
 */
@Service
@RequiredArgsConstructor
public class BranchServiceImpl implements BranchService {

    private final BranchMapper branchMapper;

    /*
    모든 지점 정보를 싹 긁어오는 기능임 (지도 전용)
     */
    @Override
    public List<BranchVO> getAllBranches() {
        // DB에 있는 모든 지점(좌표 포함)을 매퍼가 가져옴
        return branchMapper.getAllBranches();
    }

    /*
      사용자가 상세 필터로 검색할 때 수행되는 기능임
     */
    @Override
    public List<BranchVO> searchWithFilters(
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
            Double lat, // [추가] 내 위치 위도 (GPS)
            Double lng  // [추가] 내 위치 경도 (GPS)
    ) {
        // 검색용 재료들을 매퍼에게 전달함
        // 바뀐 변수명(facParking 등)과 추가된 좌표(lat, lng)를 매퍼의 주문서로 넘겨줌
        return branchMapper.searchWithFilters(
                keyword, region, capacity,
                facParking, facH24, facPet,
                facWifi, facCoffee, facPrinter, facLocker,
                lat, lng // [추가] 매퍼에게 내 위치 좌표도 같이 던져줌!
        );
    }
}