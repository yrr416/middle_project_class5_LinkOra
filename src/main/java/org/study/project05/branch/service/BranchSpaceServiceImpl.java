package org.study.project05.branch.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.branch.mapper.BranchDetailSpaceMapper;
import org.study.project05.branch.vo.BranchSpaceVO;

import java.util.List;

@Service
public class BranchSpaceServiceImpl implements BranchSpaceService {

    @Autowired
    private BranchDetailSpaceMapper branchDetailSpaceMapper;

    @Override
    public List<BranchSpaceVO> getSpaceList() {
        return branchDetailSpaceMapper.selectAll();
    }

    @Override
    public BranchSpaceVO getSpaceById(int spaceIdx) {
        return branchDetailSpaceMapper.selectById(spaceIdx);
    }

    @Override
    public List<BranchSpaceVO> getSpacesByBranch(int bIdx) {
        return branchDetailSpaceMapper.selectByBranch(bIdx);
    }
}
