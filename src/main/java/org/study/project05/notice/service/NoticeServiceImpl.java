package org.study.project05.notice.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.notice.mapper.NoticeMapper;
import org.study.project05.notice.vo.NoticeVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 공지 관리 서비스 구현 클래스
 */
@Service
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    private NoticeMapper noticeMapper;

    /** 전체 공지 수 (검색/필터 조건 포함) */
    @Override
    public int getNoticeCount(NoticeVO noticeVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("noticeVO", noticeVO);
        return noticeMapper.getNoticeCount(map);
    }

    /** 공지 목록 조회 */
    @Override
    public List<NoticeVO> getNoticeList(int numPerPage, int offset, NoticeVO noticeVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("numPerPage", numPerPage);
        map.put("offset", offset);
        map.put("noticeVO", noticeVO);
        return noticeMapper.getNoticeList(map);
    }

    /** 공지 단건 조회 */
    @Override
    public NoticeVO getNoticeDetail(String n_idx) {
        return noticeMapper.getNoticeDetail(n_idx);
    }

    /** 공지 등록 */
    @Override
    public int insertNotice(NoticeVO noticeVO) {
        return noticeMapper.insertNotice(noticeVO);
    }

    /** 공지 수정 */
    @Override
    public int updateNotice(NoticeVO noticeVO) {
        return noticeMapper.updateNotice(noticeVO);
    }

    /** 고정 여부 토글 (n_active: 0→1, 1→0) */
    @Override
    public int toggleNoticeActive(String n_idx) {
        return noticeMapper.toggleNoticeActive(n_idx);
    }

    /** 공지 삭제 */
    @Override
    public int deleteNotice(String n_idx) {
        return noticeMapper.deleteNotice(n_idx);
    }

    /** 이전 공지 */
    @Override
    public NoticeVO getPrevNotice(String ntcIdx) {
        return noticeMapper.getPrevNotice(ntcIdx);
    }

    /** 다음 공지 */
    @Override
    public NoticeVO getNextNotice(String ntcIdx) {
        return noticeMapper.getNextNotice(ntcIdx);
    }
}
