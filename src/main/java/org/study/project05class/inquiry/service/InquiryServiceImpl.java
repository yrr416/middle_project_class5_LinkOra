package org.study.project05class.inquiry.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05class.inquiry.mapper.InquiryMapper;
import org.study.project05class.inquiry.vo.InquiryVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 1:1 문의 관리 서비스 구현 클래스
 */
@Service
public class InquiryServiceImpl implements InquiryService {

    @Autowired
    private InquiryMapper inquiryMapper;

    /** 전체 문의 수 (상태 필터 포함) */
    @Override
    public int getInquiryCount(InquiryVO inquiryVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("inquiryVO", inquiryVO);
        return inquiryMapper.getInquiryCount(map);
    }

    /** 문의 목록 조회 (미답변 PENDING 우선 정렬) */
    @Override
    public List<InquiryVO> getInquiryList(int numPerPage, int offset, InquiryVO inquiryVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("numPerPage", numPerPage);
        map.put("offset", offset);
        map.put("inquiryVO", inquiryVO);
        return inquiryMapper.getInquiryList(map);
    }

    /** 문의 단건 상세 조회 */
    @Override
    public InquiryVO getInquiryDetail(String iIdx) {
        return inquiryMapper.getInquiryDetail(iIdx);
    }

    /**
     * 답변 저장
     * - iAnswer 저장
     * - iStatus = 'COMPLETE' 자동 변경
     * - iAnswered = NOW()
     */
    @Override
    public int saveAnswer(String iIdx, String answer) {
        Map<String, Object> map = new HashMap<>();
        map.put("inqIdx",    iIdx);
        map.put("inqAnswer", answer);
        return inquiryMapper.saveAnswer(map);
    }

    /** 미답변 문의 수 (대시보드 알림용) */
    @Override
    public int getPendingCount() {
        return inquiryMapper.getPendingCount();
    }
}
