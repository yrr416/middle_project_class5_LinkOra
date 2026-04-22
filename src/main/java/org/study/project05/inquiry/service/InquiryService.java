package org.study.project05.inquiry.service;

import org.study.project05.inquiry.vo.InquiryVO;

public interface InquiryService {
    int registerInquiry(InquiryVO vo);
    java.util.Map<String, Object> getInquiryList(Long userIdx, int page, String status);
    InquiryVO getInquiryDetail(Integer inqIdx);
    String updateInquiry(InquiryVO vo, int userIdx);
    String deleteInquiry(Integer inqIdx, int userIdx);
}
