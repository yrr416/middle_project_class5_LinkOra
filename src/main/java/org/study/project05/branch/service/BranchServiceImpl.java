package org.study.project05.branch.service;

import org.study.project05.branch.vo.BranchVO;
import org.study.project05.branch.mapper.BranchMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BranchServiceImpl implements BranchService {

    private final BranchMapper branchMapper;

    @Override
    public List<BranchVO> getAllBranches() {
        return branchMapper.getAllBranches();
    }

    @Override
    public List<BranchVO> searchWithFilters(
            String keyword, String region, Integer capacity,
            // [수정] 인터페이스 약속에 맞춰 type 파라미터 추가
            String type,
            Integer facParking, Integer facHours24, Integer facPet,
            Integer facWifi, Integer facCoffee, Integer facPrinter, Integer facLocker,
            Double lat, Double lng, Integer skip, Integer size
    ) {
        // [작동] 매퍼(DB)로 type 값을 포함해서 15개 파라미터를 전달함
        return branchMapper.searchWithFilters(
                keyword, region, capacity, type, facParking, facHours24, facPet,
                facWifi, facCoffee, facPrinter, facLocker, lat, lng, skip, size
        );
    }

    /* [빨간 줄 해결 포인트] 메서드 이름과 파라미터를 인터페이스/매퍼와 완벽히 일치시킴 */
    @Override
    public int getCountWithFilters(
            String keyword, String region, Integer capacity,
            // [수정] 개수 세는 기능에서도 type 파라미터 추가
            String type,
            Integer facParking, Integer facHours24, Integer facPet,
            Integer facWifi, Integer facCoffee, Integer facPrinter, Integer facLocker,
            Double lat, Double lng
    ) {
        // [작동] 매퍼의 getCountWithFilters를 부르면서 type도 같이 던져줌!
        return branchMapper.getCountWithFilters(
                keyword, region, capacity, type, facParking, facHours24, facPet,
                facWifi, facCoffee, facPrinter, facLocker, lat, lng
        );
    }
}