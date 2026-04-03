package org.study.midproject.inquiry.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.midproject.inquiry.mapper.InquiryMapper;
import org.study.midproject.inquiry.vo.InquiryVO;
import java.util.List;

@Service
public class InquiryServiceImpl implements InquiryService {
    
    private final InquiryMapper inquiryMapper;

    @Autowired
    public InquiryServiceImpl(InquiryMapper inquiryMapper) {
        this.inquiryMapper = inquiryMapper;
    }

    @Override
    public int registerInquiry(InquiryVO vo) {
        return inquiryMapper.insertInquiry(vo);
    }

    @Override
    public List<InquiryVO> getInquiryList(Long userIdx) {
        return inquiryMapper.selectInquiryListByUser(userIdx);
    }

    @Override
    public InquiryVO getInquiryDetail(Integer idx) {
        return inquiryMapper.selectInquiryDetail(idx);
    }
}
