package org.study.project05class.notice.service;

import org.study.project05class.notice.vo.NoticeVO;

import java.util.List;

/**
 * 공지 관리 서비스 인터페이스
 */
public interface NoticeService {

    /** 전체 공지 수 */
    int getNoticeCount(NoticeVO noticeVO);

    /** 공지 목록 조회 */
    List<NoticeVO> getNoticeList(int numPerPage, int offset, NoticeVO noticeVO);

    /** 공지 단건 조회 */
    NoticeVO getNoticeDetail(String n_idx);

    /** 공지 등록 */
    int insertNotice(NoticeVO noticeVO);

    /** 공지 수정 */
    int updateNotice(NoticeVO noticeVO);

    /** 고정 여부 토글 */
    int toggleNoticeActive(String n_idx);

    /** 공지 삭제 */
    int deleteNotice(String n_idx);
}
