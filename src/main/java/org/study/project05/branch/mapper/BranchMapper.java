package org.study.project05.branch.mapper;

import org.study.project05.branch.vo.BranchVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface BranchMapper {

    /**
     * 지도에 모든 지점 정보를 싹 뿌려주기 위한 기능
     */
    List<BranchVO> getAllBranches();

    /**
     * 상세 필터와 키워드로 지점을 검색하는 기능 (페이징 포함)
     * [수정] skip과 size 파라미터를 추가하여 원하는 구간만큼만 가져오게 함
     */
    List<BranchVO> searchWithFilters(
            @Param("keyword") String keyword,
            @Param("region") String region,
            @Param("capacity") Integer capacity,
            @Param("facParking") Integer facParking,
            @Param("facHours24") Integer facHours24,
            @Param("facPet") Integer facPet,
            @Param("facWifi") Integer facWifi,
            @Param("facCoffee") Integer facCoffee,
            @Param("facPrinter") Integer facPrinter,
            @Param("facLocker") Integer facLocker,
            @Param("lat") Double lat,
            @Param("lng") Double lng,
            @Param("skip") Integer skip, // [추가] 건너뛸 개수
            @Param("size") Integer size  // [추가] 가져올 개수
    );

    /**
     * [추가] 필터 조건에 맞는 전체 지점의 개수를 가져옴
     * 페이지 번호(1 2 3...)를 계산하기 위해 반드시 필요함
     */
    int getCountWithFilters(
            @Param("keyword") String keyword,
            @Param("region") String region,
            @Param("capacity") Integer capacity,
            @Param("facParking") Integer facParking,
            @Param("facHours24") Integer facHours24,
            @Param("facPet") Integer facPet,
            @Param("facWifi") Integer facWifi,
            @Param("facCoffee") Integer facCoffee,
            @Param("facPrinter") Integer facPrinter,
            @Param("facLocker") Integer facLocker,
            @Param("lat") Double lat,
            @Param("lng") Double lng
    );
}