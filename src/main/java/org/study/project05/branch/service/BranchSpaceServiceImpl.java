package org.study.project05.branch.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.branch.mapper.BranchSpaceMapper;
import org.study.project05.branch.vo.BranchSpaceVO;

import java.util.List;

@Service
public class BranchSpaceServiceImpl implements BranchSpaceService {

    @Autowired
    private BranchSpaceMapper branchSpaceMapper;

    @Override
    public List<BranchSpaceVO> getSpaceList() {
        return branchSpaceMapper.selectAll();
    }

    @Override
    public BranchSpaceVO getSpaceById(int spaceIdx) {
        return branchSpaceMapper.selectById(spaceIdx);
    }

    @Override
    public List<BranchSpaceVO> getSpacesByBranch(int bIdx) {
        return branchSpaceMapper.selectByBranch(bIdx);
    }
}
