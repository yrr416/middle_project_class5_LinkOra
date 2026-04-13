package org.study.project05.branch.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05.branch.vo.BranchImgVO;

import java.util.List;

@Mapper
public interface BranchImgMapper {

    List<BranchImgVO> selectByBranch(int bIdx);

    BranchImgVO selectMainByBranch(int bIdx);
}
