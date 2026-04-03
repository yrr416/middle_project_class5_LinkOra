package org.study.midproject.inquiry.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.midproject.inquiry.vo.InquiryVO;
import java.util.List;

@Mapper
public interface InquiryMapper {
    // 문의글 등록
    int insertInquiry(InquiryVO vo);
    
    // 특정 사용자의 문의 내역 리스트 조회
    List<InquiryVO> selectInquiryListByUser(@Param("userIdx") Long userIdx);
    
    // 특정 문의글 상세 조회
    InquiryVO selectInquiryDetail(@Param("idx") Integer idx);
}
