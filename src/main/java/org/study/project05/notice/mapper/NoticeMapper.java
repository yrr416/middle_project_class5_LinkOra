package org.study.project05.notice.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05.notice.vo.NoticeVO;

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

    /** 이전 공지 (현재보다 idx 작은 것 중 최대) */
    NoticeVO getPrevNotice(String ntcIdx);

    /** 다음 공지 (현재보다 idx 큰 것 중 최소) */
    NoticeVO getNextNotice(String ntcIdx);
}
