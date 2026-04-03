package org.study.midproject.inquiry.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.study.midproject.inquiry.mapper.InquiryMapper;
import org.study.midproject.inquiry.vo.InquiryVO;
import java.util.List;

public interface InquiryService {
    int registerInquiry(InquiryVO vo);
    List<InquiryVO> getInquiryList(Integer userIdx);
    InquiryVO getInquiryDetail(Integer idx);
}

@Service
@RequiredArgsConstructor
class InquiryServiceImpl implements InquiryService {
    private final InquiryMapper inquiryMapper;

    @Override
    public int registerInquiry(InquiryVO vo) {
        return inquiryMapper.insertInquiry(vo);
    }

    @Override
    public List<InquiryVO> getInquiryList(Integer userIdx) {
        return inquiryMapper.selectInquiryListByUser(userIdx);
    }

    @Override
    public InquiryVO getInquiryDetail(Integer idx) {
        return inquiryMapper.selectInquiryDetail(idx);
    }
}
