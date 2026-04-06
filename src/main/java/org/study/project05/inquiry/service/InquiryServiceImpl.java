package org.study.project05.inquiry.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.inquiry.mapper.InquiryMapper;
import org.study.project05.inquiry.vo.InquiryVO;
import org.study.project05.common.Paging;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

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
    public Map<String, Object> getInquiryList(Long userIdx, int page) {
        int totalRecord = inquiryMapper.countInquiriesByUser(userIdx);
        
        Paging paging = new Paging();
        paging.setTotalRecord(totalRecord);
        paging.setNowPage(page);
        
        // 전체 페이지 수 계산
        int totalPage = (int) Math.ceil((double) totalRecord / paging.getNumPerPage());
        paging.setTotalPage(totalPage > 0 ? totalPage : 1);
        
        // MySQL LIMIT용 offset 계산
        paging.setOffset((paging.getNowPage() - 1) * paging.getNumPerPage());
        
        // 블록 계산 (이전/다음 버튼용)
        int beginBlock = ((paging.getNowPage() - 1) / paging.getPagePerBlock()) * paging.getPagePerBlock() + 1;
        paging.setBeginBlock(beginBlock);
        int endBlock = beginBlock + paging.getPagePerBlock() - 1;
        paging.setEndBlock(endBlock > paging.getTotalPage() ? paging.getTotalPage() : endBlock);
        
        List<InquiryVO> list = inquiryMapper.selectInquiryListByUser(userIdx, paging.getNumPerPage(), paging.getOffset());
        
        Map<String, Object> result = new HashMap<>();
        result.put("inquiryList", list);
        result.put("paging", paging);
        
        return result;
    }

    @Override
    public InquiryVO getInquiryDetail(Integer idx) {
        return inquiryMapper.selectInquiryDetail(idx);
    }
}
