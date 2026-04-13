package org.study.project05.branch.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Component;
import org.study.project05.branch.vo.SpaceVO;

import java.util.List;

@Mapper
@Component("branchSpaceMapper")
public interface SpaceMapper {

    List<SpaceVO> selectAll();

    SpaceVO selectById(int spaceIdx);

    List<SpaceVO> selectByBranch(int bIdx);
}
