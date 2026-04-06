package org.study.project05.inquiry.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.inquiry.vo.InquiryVO;
import java.util.List;

@Mapper
public interface InquiryMapper {
    // 문의글 등록
    int insertInquiry(InquiryVO vo);
    
    // 특정 사용자의 전체 문의 개수 조회 (페이징용)
    int countInquiriesByUser(@Param("uidx") Long userIdx);
    
    // 특정 사용자의 문의 내역 리스트 조회 (페이징 적용)
    List<InquiryVO> selectInquiryListByUser(@Param("uidx") Long userIdx, @Param("limit") int limit, @Param("offset") int offset);
    
    // 특정 문의글 상세 조회
    InquiryVO selectInquiryDetail(@Param("iidx") Integer idx);
}
