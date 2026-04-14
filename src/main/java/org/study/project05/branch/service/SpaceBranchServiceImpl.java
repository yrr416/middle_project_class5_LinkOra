package org.study.project05.branch.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.branch.mapper.*;
import org.study.project05.branch.vo.BranchVO;
import org.study.project05.branch.vo.SpaceVO;

import java.util.List;

@Service
public class SpaceBranchServiceImpl implements SpaceBranchService {

    @Autowired private SpaceBranchMapper spaceBranchMapper;
    @Autowired private BranchMapper branchMapper;
    @Autowired private SpaceMapper       spaceMapper;
    @Autowired private FacilityMapper    facilityMapper;
    @Autowired private BranchImgMapper   branchImgMapper;

    @Override
    public List<BranchVO> getAllBranches() {
        List<BranchVO> branches = branchMapper.getAllBranches();
        for (BranchVO b : branches) {
            b.setImages(branchImgMapper.selectByBranch(b.getBrnIdx()));
        }
        return branches;
    }

    @Override
    public BranchVO getBranchWithSpaces(int bIdx) {
        BranchVO branch = spaceBranchMapper.selectById(bIdx);
        if (branch != null) {
            List<SpaceVO> spaces = spaceMapper.selectByBranch(bIdx);
            for (SpaceVO s : spaces) {
                // spcIdx를 spaIdx 파라미터로 전달
                s.setFacilities(facilityMapper.selectBySpaceIdx(s.getSpcIdx()));
            }
            branch.setSpaces(spaces);
            branch.setImages(branchImgMapper.selectByBranch(bIdx));
        }
        return branch;
    }

    @Override
    public BranchVO getBranchBySpaceIdx(int spaIdx) {
        return spaceBranchMapper.selectBySpaceIdx(spaIdx);
    }

    @Override
    public SpaceVO getSpaceById(int spcIdx) {
        return spaceMapper.selectById(spcIdx);
    }
}
