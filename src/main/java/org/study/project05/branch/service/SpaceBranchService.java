package org.study.project05.branch.service;

import org.study.project05.branch.vo.BranchVO;

import java.util.List;

public interface SpaceBranchService {

    List<BranchVO> getAllBranches();

    BranchVO getBranchWithSpaces(int bIdx);

    BranchVO getBranchBySpaceIdx(int spaIdx);
}
