package org.study.project05.inquiry.service;

import org.study.project05.inquiry.vo.InquiryVO;

import java.util.List;

/**
 * 1:1 문의 관리 서비스 인터페이스
 */
public interface InquiryService {

    /** 전체 문의 수 */
    int getInquiryCount(InquiryVO inquiryVO);

    /** 문의 목록 조회 (미답변 우선 정렬) */
    List<InquiryVO> getInquiryList(int numPerPage, int offset, InquiryVO inquiryVO);

    /** 문의 단건 상세 조회 */
    InquiryVO getInquiryDetail(String i_idx);

    /**
     * 답변 저장
     * - i_answer 저장
     * - i_status 자동 COMPLETE 변경
     * - i_answered 현재시간 저장
     */
    int saveAnswer(String i_idx, String answer);

    /** 미답변 문의 수 */
    int getPendingCount();
}
