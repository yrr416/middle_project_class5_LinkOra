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
            Integer facParking, Integer facHours24, Integer facPet,
            Integer facWifi, Integer facCoffee, Integer facPrinter, Integer facLocker,
            Double lat, Double lng, Integer skip, Integer size
    ) {
        return branchMapper.searchWithFilters(
                keyword, region, capacity, facParking, facHours24, facPet,
                facWifi, facCoffee, facPrinter, facLocker, lat, lng, skip, size
        );
    }

    /* [빨간 줄 해결 포인트] 메서드 이름과 파라미터를 인터페이스/매퍼와 완벽히 일치시킴 */
    @Override
    public int getCountWithFilters(
            String keyword, String region, Integer capacity,
            Integer facParking, Integer facHours24, Integer facPet,
            Integer facWifi, Integer facCoffee, Integer facPrinter, Integer facLocker,
            Double lat, Double lng
    ) {
        // 이제 매퍼의 getCountWithFilters를 부르면서 lat, lng도 같이 던져줌!
        return branchMapper.getCountWithFilters(
                keyword, region, capacity, facParking, facHours24, facPet,
                facWifi, facCoffee, facPrinter, facLocker, lat, lng
        );
    }
}