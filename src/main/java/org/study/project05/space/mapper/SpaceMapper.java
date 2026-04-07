package org.study.project05.space.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05.space.vo.SpaceVO;

import java.util.List;

@Mapper
public interface SpaceMapper {
    /** 전체 공간 목록 (레거시 — 현재는 BranchMapper.selectAll() 권장) */
    List<SpaceVO> selectAll();

    /** 공간 단건 조회 */
    SpaceVO selectById(int spaceIdx);

    /** 지점에 속한 공간 목록 */
    List<SpaceVO> selectByBranch(int bIdx);
}
