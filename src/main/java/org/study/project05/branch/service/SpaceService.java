package org.study.project05.branch.service;

import org.study.project05.branch.vo.SpaceVO;

import java.util.List;

public interface SpaceService {

    List<SpaceVO> getSpaceList();

    SpaceVO getSpaceById(int spaceIdx);

    List<SpaceVO> getSpacesByBranch(int bIdx);
}
