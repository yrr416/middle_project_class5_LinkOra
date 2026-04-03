package org.study.project05class.space.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05class.space.vo.SpaceVO;

import java.util.List;
import java.util.Map;

/**
 * 공간 관련 DB 처리 매퍼 인터페이스
 * MyBatis를 통해 SpaceMapper.xml 과 연동
 */
@Mapper
public interface SpaceMapper {

    // 전체 공간 수 (필터 포함)
    int getSpaceCount(Map<String, Object> map);

    // 공간 목록 조회 (페이징 + 필터)
    List<SpaceVO> getSpaceList(Map<String, Object> map);

    // 파트너 신청 대기 목록 (s_active = 0)
    List<SpaceVO> getPendingSpaceList();

    // 공간 상세 조회
    SpaceVO getSpaceDetail(String s_idx);

    // 공간 등록
    int insertSpace(SpaceVO spaceVO);

    // 공간 정보 수정
    int updateSpace(SpaceVO spaceVO);

    // 활성/비활성 토글 (1 ↔ 2)
    int toggleSpaceActive(SpaceVO spaceVO);

    // 파트너 매물 수락 (s_active = 1)
    int approveSpace(String s_idx);

    // 파트너 매물 거부 (DELETE)
    int rejectSpace(String s_idx);

    // 지점 목록 조회 (등록 폼 드롭다운용)
    List<Map<String, Object>> getBranchList();
}
