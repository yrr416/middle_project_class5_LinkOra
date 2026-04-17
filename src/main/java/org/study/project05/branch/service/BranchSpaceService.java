package org.study.project05.branch.service;

import org.study.project05.branch.vo.BranchSpaceVO;
import java.util.List;

public interface BranchSpaceService {
    List<BranchSpaceVO> getSpaceList();
    BranchSpaceVO getSpaceById(int spaceIdx);
    List<BranchSpaceVO> getSpacesByBranch(int bIdx);
}
