package org.study.project05.branch.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05.branch.vo.SpaceVO;

import java.util.List;

@Mapper
public interface SpaceMapper {

    SpaceVO selectById(int spaceIdx);

    List<SpaceVO> selectByBranch(int bIdx);
}
