package org.study.project05.branch.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.branch.vo.FacilityVO;

@Mapper
public interface FacilityMapper {
    /** 공간별 편의시설 조회 — spaIdx: 공간 번호 */
    FacilityVO selectBySpaceIdx(@Param("spaIdx") int spaIdx);
}
