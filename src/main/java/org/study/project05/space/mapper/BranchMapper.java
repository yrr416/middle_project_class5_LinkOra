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
}
