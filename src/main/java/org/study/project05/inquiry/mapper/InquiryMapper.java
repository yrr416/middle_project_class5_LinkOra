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
    int countInquiriesByUser(@Param("userIdx") Long userIdx);
    
    // 특정 사용자의 문의 내역 리스트 조회 (페이징 적용)
    List<InquiryVO> selectInquiryListByUser(@Param("userIdx") Long userIdx, @Param("limit") int limit, @Param("offset") int offset);
    
    /**
     * 특정 문의 상세 내용 및 관리자 답변 조회
     * @param inqIdx 문의 ID
     * @return 문의 정보
     */
    InquiryVO selectInquiryDetail(@Param("inqIdx") Integer inqIdx);

    /**
     * 문의 수정
     * @param vo 수정할 문의 정보
     * @return 성공 여부
     */
    int updateInquiry(InquiryVO vo);

    /**
     * 문의 삭제
     * @param inqIdx 삭제할 문의 ID
     * @return 성공 여부
     */
    int deleteInquiry(@Param("inqIdx") Integer inqIdx);
}
