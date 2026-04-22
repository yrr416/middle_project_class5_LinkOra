package org.study.project05.inquiry.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.inquiry.vo.InquiryVO;
import java.util.List;

@Mapper
public interface InquiryMapper {
    // 문의글 등록
    int insertInquiry(InquiryVO vo);
    
    // 특정 사용자의 전체 문의 개수 조회 (페이징용 + 필터)
    int countInquiriesByUser(@Param("userIdx") Long userIdx, @Param("status") String status);
    
    // 특정 사용자의 문의 내역 리스트 조회 (페이징 + 필터 적용)
    List<InquiryVO> selectInquiryListByUser(@Param("userIdx") Long userIdx, 
                                            @Param("limit") int limit, 
                                            @Param("offset") int offset,
                                            @Param("status") String status);
    
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

    /* ===== 관리자 전용 ===== */

    /** 전체 문의 수 (상태·검색어 필터) */
    int countAllForAdmin(@Param("statusFilter") String statusFilter,
                         @Param("searchWord")   String searchWord);

    /** 미답변 문의 수 */
    int countPending();

    /** 전체 문의 목록 (페이징 + 필터) */
    List<InquiryVO> selectAllForAdmin(@Param("statusFilter") String statusFilter,
                                      @Param("searchWord")   String searchWord,
                                      @Param("offset")       int    offset,
                                      @Param("limit")        int    limit);

    /** 관리자 답변 저장 (상태 → COMPLETE, i_answered = NOW()) */
    int answerInquiry(@Param("inqIdx")    Integer inqIdx,
                      @Param("inqAnswer") String  inqAnswer);

    /* ===== 답변 템플릿 관리 ===== */

    /** 전체 템플릿 목록 조회 */
    List<java.util.Map<String, Object>> selectAllTemplates();

    /** 템플릿 추가 */
    int insertTemplate(@Param("title")   String title,
                       @Param("content") String content);

    /** 템플릿 삭제 */
    int deleteTemplate(@Param("tIdx") int tIdx);
}
