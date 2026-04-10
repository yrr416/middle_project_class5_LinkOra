package org.study.project05.space.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05.space.vo.FacilityVO;

@Mapper
public interface FacilityMapper {
    /** 공간별 시설 정보 조회 */
    FacilityVO selectBySpaceIdx(int spcIdx);
}
