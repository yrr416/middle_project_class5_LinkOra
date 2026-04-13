package org.study.project05.space.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.study.project05.space.mapper.SpaceMapper;
import org.study.project05.space.vo.SpaceVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 공간 관리 서비스 구현 클래스
 */
@Service("adminSpaceServiceImpl")
public class SpaceServiceImpl implements SpaceService {

    @Autowired
    private SpaceMapper spaceMapper;

    @Override
    public int getSpaceCount(SpaceVO spaceVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("spaceVO", spaceVO);
        return spaceMapper.getSpaceCount(map);
    }

    @Override
    public List<SpaceVO> getSpaceList(int numPerPage, int offset, SpaceVO spaceVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("numPerPage", numPerPage);
        map.put("offset", offset);
        map.put("spaceVO", spaceVO);
        return spaceMapper.getSpaceList(map);
    }

    @Override
    public List<SpaceVO> getPendingSpaceList() {
        return spaceMapper.getPendingSpaceList();
    }

    @Override
    public SpaceVO getSpaceDetail(String s_idx) {
        return spaceMapper.getSpaceDetail(s_idx);
    }

    @Override
    public int insertSpace(SpaceVO spaceVO) {
        return spaceMapper.insertSpace(spaceVO);
    }

    @Override
    public int updateSpace(SpaceVO spaceVO) {
        return spaceMapper.updateSpace(spaceVO);
    }

    @Override
    public int toggleSpaceActive(SpaceVO spaceVO) {
        return spaceMapper.toggleSpaceActive(spaceVO);
    }

    @Override
    public int approveSpace(String s_idx) {
        return spaceMapper.approveSpace(s_idx);
    }

    @Override
    @Transactional
    public int rejectSpace(String s_idx) {
        spaceMapper.deleteFacilitiesBySpcIdx(s_idx);
        return spaceMapper.rejectSpace(s_idx);
    }

    @Override
    @Transactional
    public int deleteSpace(String s_idx) {
        spaceMapper.deleteFacilitiesBySpcIdx(s_idx);
        return spaceMapper.deleteSpace(s_idx);
    }

    @Override
    public List<Map<String, Object>> getBranchList() {
        return spaceMapper.getBranchList();
    }
}
