package org.study.project05.branch.mapper;

import org.study.project05.branch.vo.BranchVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface BranchMapper {

    /**
     지도에 모든 지점 정보를 싹 뿌려주기 위한 기능
     XML에 만든 <select id="getAllBranches">와 연결
     */
    List<BranchVO> getAllBranches();

    /**
     * 상세 필터와 키워드로 지점을 검색하는 기능
     * [추가] 현재 위치(GPS) 기반 거리 계산을 위해 lat, lng 매개변수 추가
     */
    List<BranchVO> searchWithFilters(
            @Param("keyword") String keyword,
            @Param("region") String region,
            @Param("capacity") Integer capacity,
            @Param("parking") Integer parking,
            @Param("h24") Integer h24,
            @Param("pet") Integer pet,
            @Param("wifi") Integer wifi,
            @Param("coffee") Integer coffee,
            @Param("printer") Integer printer,
            @Param("locker") Integer locker,
            @Param("lat") Double lat, // [추가] JS에서 넘어온 내 위치 위도
            @Param("lng") Double lng  // [추가] JS에서 넘어온 내 위치 경도
    );
}