package org.study.project05.branch.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.branch.vo.BranchVO;

import java.util.List;

/**
 * partner JOIN 포함 지점 상세 조회 매퍼 (상세페이지, 예약폼용)
 * 팀원의 BranchMapper(검색/필터용)와 역할이 다름
 */
@Mapper
public interface SpaceBranchMapper {

    BranchVO selectById(@Param("brnIdx") int brnIdx);

    /** 특정 공간이 속한 지점 조회 — spaIdx: 공간 번호 */
    BranchVO selectBySpaceIdx(@Param("spaIdx") int spaIdx);
}
