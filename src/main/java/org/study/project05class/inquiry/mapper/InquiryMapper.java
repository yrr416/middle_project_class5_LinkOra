package org.study.project05class.inquiry.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05class.inquiry.vo.InquiryVO;

import java.util.List;
import java.util.Map;

/**
 * 1:1 문의 관리 Mapper 인터페이스
 */
@Mapper
public interface InquiryMapper {

    /** 전체 문의 수 (필터 포함) */
    int getInquiryCount(Map<String, Object> map);

    /** 문의 목록 조회 (미답변 우선 정렬) */
    List<InquiryVO> getInquiryList(Map<String, Object> map);

    /** 문의 단건 상세 조회 */
    InquiryVO getInquiryDetail(String i_idx);

    /**
     * 답변 저장 + 상태 자동 변경
     * - i_answer 저장
     * - i_status = 'COMPLETE'
     * - i_answered = NOW()
     */
    int saveAnswer(Map<String, Object> map);

    /** 미답변 문의 수 (대시보드용) */
    int getPendingCount();
}
