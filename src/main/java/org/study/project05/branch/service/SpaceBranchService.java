package org.study.project05.branch.service;

import org.study.project05.branch.vo.BranchVO;
import org.study.project05.branch.vo.SpaceVO;

import java.util.List;

public interface SpaceBranchService {

    List<BranchVO> getAllBranches();

    BranchVO getBranchWithSpaces(int bIdx);

    BranchVO getBranchBySpaceIdx(int spaIdx);

    SpaceVO getSpaceById(int spcIdx);
}
