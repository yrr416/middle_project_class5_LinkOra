package org.study.project05class.notice.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05class.notice.vo.NoticeVO;

import java.util.List;
import java.util.Map;

/**
 * 공지 관리 Mapper 인터페이스
 */
@Mapper
public interface NoticeMapper {

    /** 전체 공지 수 (검색 조건 포함) */
    int getNoticeCount(Map<String, Object> map);

    /** 공지 목록 조회 (페이징 + 필터) */
    List<NoticeVO> getNoticeList(Map<String, Object> map);

    /** 공지 단건 조회 */
    NoticeVO getNoticeDetail(String n_idx);

    /** 공지 등록 */
    int insertNotice(NoticeVO noticeVO);

    /** 공지 수정 */
    int updateNotice(NoticeVO noticeVO);

    /** 고정 여부 토글 (n_active: 0↔1) */
    int toggleNoticeActive(String n_idx);

    /** 공지 삭제 */
    int deleteNotice(String n_idx);
}
