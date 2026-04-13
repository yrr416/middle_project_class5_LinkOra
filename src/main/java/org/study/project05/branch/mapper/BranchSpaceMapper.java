package org.study.project05.branch.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05.branch.vo.BranchSpaceVO;

import java.util.List;

@Mapper
public interface BranchSpaceMapper {

    List<BranchSpaceVO> selectAll();

    BranchSpaceVO selectById(int spaceIdx);

    List<BranchSpaceVO> selectByBranch(int bIdx);
}
