package org.study.project05.branch.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.branch.mapper.SpaceMapper;
import org.study.project05.branch.vo.SpaceVO;

import java.util.List;

@Service
public class SpaceServiceImpl implements SpaceService {

    @Autowired
    private SpaceMapper spaceMapper;

    @Override
    public List<SpaceVO> getSpaceList() {
        return spaceMapper.selectAll();
    }

    @Override
    public SpaceVO getSpaceById(int spaceIdx) {
        return spaceMapper.selectById(spaceIdx);
    }

    @Override
    public List<SpaceVO> getSpacesByBranch(int bIdx) {
        return spaceMapper.selectByBranch(bIdx);
    }
}
