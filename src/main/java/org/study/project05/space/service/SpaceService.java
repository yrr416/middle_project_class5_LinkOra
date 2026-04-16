package org.study.project05.space.service;

import org.study.project05.space.vo.SpaceVO;

import java.util.List;
import java.util.Map;

/**
 * 공간(오피스) 관리 서비스 인터페이스
 */
public interface SpaceService {

    int getSpaceCount(SpaceVO spaceVO);

    List<SpaceVO> getSpaceList(int numPerPage, int offset, SpaceVO spaceVO);

    List<SpaceVO> getPendingSpaceList();

    SpaceVO getSpaceDetail(String s_idx);

    int insertSpace(SpaceVO spaceVO);

    int updateSpace(SpaceVO spaceVO);

    int toggleSpaceActive(SpaceVO spaceVO);

    int approveSpace(String s_idx);

    int rejectSpace(String s_idx);

    int deleteSpace(String s_idx);

    List<Map<String, Object>> getBranchList();
}
