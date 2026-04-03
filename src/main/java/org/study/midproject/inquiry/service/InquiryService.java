package org.study.midproject.inquiry.service;

import org.study.midproject.inquiry.vo.InquiryVO;
import java.util.List;

public interface InquiryService {
    int registerInquiry(InquiryVO vo);
    List<InquiryVO> getInquiryList(Long userIdx);
    InquiryVO getInquiryDetail(Integer idx);
}
