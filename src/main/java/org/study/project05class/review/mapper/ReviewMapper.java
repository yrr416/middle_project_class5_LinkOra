package org.study.project05class.review.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05class.review.vo.ReviewReportVO;
import org.study.project05class.review.vo.ReviewVO;

import java.util.List;
import java.util.Map;

/**
 * 리뷰 관련 DB 처리 매퍼 인터페이스
 * MyBatis를 통해 ReviewMapper.xml 과 연동
 */
@Mapper
public interface ReviewMapper {

    // ─── 리뷰 목록 ───────────────────────────────────────────────

    /** 전체 리뷰 수 (원본 리뷰만) */
    int getReviewCount(Map<String, Object> map);

    /** 답변완료 리뷰 수 */
    int getAnsweredReviewCount();

    /** 리뷰 목록 조회 (페이징 + 필터, 신고 수 포함) */
    List<ReviewVO> getReviewList(Map<String, Object> map);

    /** 리뷰 상세 단건 조회 */
    ReviewVO getReviewDetail(String v_idx);

    // ─── 관리자 답글 ──────────────────────────────────────────────

    /**
     * 관리자 답글 등록 (v_parent_idx = 원본 리뷰의 v_idx)
     * 답글이 존재하면 원본 리뷰는 관리자 페이지에서 자동으로 숨겨짐
     * (v_active 변경 없이 v_parent_idx 존재 여부로 처리완료 판단)
     */
    int insertAdminReply(ReviewVO reviewVO);

    // ─── 블라인드 처리 ────────────────────────────────────────────

    /** 리뷰 활성 상태 변경 (0=일반, 1=처리완료, 2=블라인드) */
    int updateReviewActive(Map<String, Object> map);

    // ─── 신고 관련 ────────────────────────────────────────────────

    /** 신고 전체 수 */
    int getReportCount(Map<String, Object> map);

    /** 신고 목록 조회 (신고 사유, 신고자, 대상 리뷰 정보 포함) */
    List<ReviewReportVO> getReportList(Map<String, Object> map);

    /** 신고 처리 (상태 변경 + 관리자 알림 메시지 저장) */
    int updateReportStatus(Map<String, Object> map);

    /** 특정 리뷰의 전체 신고 목록 조회 */
    List<ReviewReportVO> getReportsByRevIdx(String revIdx);

    /** 리뷰 삭제 (관련 답글 포함) */
    int deleteReview(String revIdx);

    /** 관리자 답글 수정 */
    int updateAdminReply(Map<String, Object> map);

    /** 관리자 답글 삭제 */
    int deleteAdminReply(String revIdx);
}
