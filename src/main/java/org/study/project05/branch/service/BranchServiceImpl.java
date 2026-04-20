package org.study.project05.branch.service;

import org.study.project05.branch.vo.BranchVO;
import org.study.project05.branch.mapper.BranchMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

// 컬렉션 및 맵 처리를 위한 패키지 추가
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import java.util.HashSet;
import java.util.TreeMap;
import java.util.ArrayList;
import java.util.Collections;

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
            // [추가] 신규 시설 필터 4종
            Integer facCafe, Integer facKitchen, Integer facWater, Integer facLounge,
            Double lat, Double lng, Integer skip, Integer size
    ) {
        // [작동] 매퍼(DB)로 모든 필터 값을 포함해서 전달함
        return branchMapper.searchWithFilters(
                keyword, region, capacity, type, facParking, facHours24, facPet,
                facWifi, facCoffee, facPrinter, facLocker,
                facCafe, facKitchen, facWater, facLounge,
                lat, lng, skip, size
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
            // [추가] 신규 시설 필터 4종
            Integer facCafe, Integer facKitchen, Integer facWater, Integer facLounge,
            Double lat, Double lng
    ) {
        // [작동] 매퍼의 getCountWithFilters를 부르면서 모든 필터를 던져줌!
        return branchMapper.getCountWithFilters(
                keyword, region, capacity, type, facParking, facHours24, facPet,
                facWifi, facCoffee, facPrinter, facLocker,
                facCafe, facKitchen, facWater, facLounge,
                lat, lng
        );
    }

    // DB 주소를 기반으로 시/도 및 구/군 데이터를 그룹화하여 반환
    @Override
    public Map<String, List<String>> getRegionMap() {
        List<String> addresses = branchMapper.getDistinctAddresses();
        Map<String, Set<String>> tempMap = new HashMap<>();

        for (String address : addresses) {
            if (address == null || address.trim().isEmpty()) {
                continue; // 빈 주소는 무시해요!
            }

            String cleanAddress = address.trim();

            // [핵심 수정] 주소가 "서울 특별시", "서울시", "서울" 로 시작하면 모두 "서울특별시 "로 묶어줘요!
            if (cleanAddress.startsWith("서울 특별시 ")) {
                cleanAddress = cleanAddress.replaceFirst("서울 특별시 ", "서울특별시 ");
            } else if (cleanAddress.startsWith("서울시 ")) {
                cleanAddress = cleanAddress.replaceFirst("서울시 ", "서울특별시 ");
            } else if (cleanAddress.startsWith("서울 ")) {
                cleanAddress = cleanAddress.replaceFirst("서울 ", "서울특별시 ");
            }

            String[] parts = cleanAddress.split("\\s+"); // 공백을 기준으로 주소 분리
            if (parts.length >= 2) {
                String city = parts[0];
                String district = parts[1];
                // 시/도 단위로 중복 없는 구/군 셋을 생성 및 추가
                tempMap.computeIfAbsent(city, k -> new HashSet<>()).add(district);
            }
        }

        // 화면 표출을 위해 키 및 리스트 데이터를 오름차순(가나다순) 정렬
        Map<String, List<String>> resultMap = new TreeMap<>();
        for (Map.Entry<String, Set<String>> entry : tempMap.entrySet()) {
            List<String> sortedList = new ArrayList<>(entry.getValue());
            Collections.sort(sortedList);
            resultMap.put(entry.getKey(), sortedList);
        }

        return resultMap;
    }
}