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
        // [보완] 필수 입력값 검증 (서버 측)
        if (vo.getInqTitle() == null || vo.getInqTitle().trim().isEmpty())
            return 0;
        if (vo.getInqContent() == null || vo.getInqContent().trim().isEmpty())
            return 0;

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

        List<InquiryVO> list = inquiryMapper.selectInquiryListByUser(userIdx, paging.getNumPerPage(),
                paging.getOffset());

        Map<String, Object> result = new HashMap<>();
        result.put("inquiryList", list);
        result.put("paging", paging);

        return result;
    }

    @Override
    public InquiryVO getInquiryDetail(Integer inqIdx) {
        return inquiryMapper.selectInquiryDetail(inqIdx);
    }

    @Override
    public String updateInquiry(InquiryVO vo, int userIdx) {
        InquiryVO original = inquiryMapper.selectInquiryDetail(vo.getInqIdx());
        if (original == null)
            return "존재하지 않는 문의글입니다.";
        if (original.getUserIdx() != userIdx)
            return "수정 권한이 없습니다.";

        // [보완] 공백 유무와 상관없이 '답변 완료' 상태를 유연하게 체크
        String status = original.getInqStatus() != null ? original.getInqStatus().replace(" ", "") : "";
        if ("답변완료".equals(status)) {
            return "답변이 완료된 문의는 수정할 수 없습니다.";
        }

        // [보완] 입력값 검증
        if (vo.getInqTitle() == null || vo.getInqTitle().trim().isEmpty())
            return "제목을 입력해 주세요.";
        if (vo.getInqContent() == null || vo.getInqContent().trim().isEmpty())
            return "내용을 입력해 주세요.";

        int res = inquiryMapper.updateInquiry(vo);
        return (res > 0) ? "success" : "수정에 실패했습니다.";
    }

    @Override
    public String deleteInquiry(Integer inqIdx, int userIdx) {
        InquiryVO original = inquiryMapper.selectInquiryDetail(inqIdx);
        if (original == null)
            return "존재하지 않는 문의글입니다.";
        if (original.getUserIdx() != userIdx)
            return "삭제 권한이 없습니다.";

        int res = inquiryMapper.deleteInquiry(inqIdx);
        return (res > 0) ? "success" : "삭제에 실패했습니다.";
    }
}
