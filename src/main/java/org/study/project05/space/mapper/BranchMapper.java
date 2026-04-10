package org.study.project05.space.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05.space.vo.BranchVO;

import java.util.List;

@Mapper
public interface BranchMapper {
    /** 지점 전체 목록 (파트너명 JOIN) */
    List<BranchVO> selectAll();

    /** 지점 단건 조회 (파트너명 JOIN) */
    BranchVO selectById(int bIdx);

    /** 특정 공간(space)이 속한 지점 조회 — 예약폼 상단 정보 표시용 */
    BranchVO selectBySpaceIdx(int sIdx);

    /** [추가] 필터 및 위치 기반 복합 검색 (참조 프로젝트 로직 이식) */
    List<BranchVO> searchWithFilters(
            @org.apache.ibatis.annotations.Param("keyword") String keyword,
            @org.apache.ibatis.annotations.Param("capacity") Integer capacity,
            @org.apache.ibatis.annotations.Param("facParking") Integer facParking,
            @org.apache.ibatis.annotations.Param("facHours24") Integer facHours24,
            @org.apache.ibatis.annotations.Param("facPet") Integer facPet,
            @org.apache.ibatis.annotations.Param("facWifi") Integer facWifi,
            @org.apache.ibatis.annotations.Param("facCoffee") Integer facCoffee,
            @org.apache.ibatis.annotations.Param("facPrinter") Integer facPrinter,
            @org.apache.ibatis.annotations.Param("facLocker") Integer facLocker,
            @org.apache.ibatis.annotations.Param("lat") Double lat,
            @org.apache.ibatis.annotations.Param("lng") Double lng
    );
}

