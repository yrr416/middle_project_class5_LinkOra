package org.study.project05class.review.service;

import org.study.project05class.review.vo.ReviewReportVO;
import org.study.project05class.review.vo.ReviewVO;

import java.util.List;

/**
 * 리뷰 관리 서비스 인터페이스
 */
public interface ReviewService {

    // ─── 리뷰 목록 ───────────────────────────────────────────────

    /** 전체 리뷰 수 (필터 포함) */
    int getReviewCount(ReviewVO reviewVO);

    /** 답변완료 리뷰 수 */
    int getAnsweredReviewCount();

    /** 리뷰 목록 조회 (페이징 + 필터) */
    List<ReviewVO> getReviewList(int numPerPage, int offset, ReviewVO reviewVO);

    /** 리뷰 상세 조회 */
    ReviewVO getReviewDetail(String v_idx);

    // ─── 관리자 답글 ──────────────────────────────────────────────

    /**
     * 관리자 답글 등록
     * - 새 review 레코드 insert (v_parent_idx = 원본 v_idx, u_idx = 0 관리자)
     * - 원본 리뷰의 v_active는 변경하지 않음
     * - 관리자 목록 숨김은 v_parent_idx 존재 여부로 판단
     */
    int insertAdminReply(String v_idx, String replyContent);

    // ─── 블라인드 처리 ────────────────────────────────────────────

    /** 리뷰 블라인드 처리 (v_active = 2) */
    int blindReview(String v_idx);

    /** 리뷰 블라인드 해제 (v_active = 0) */
    int unblindReview(String v_idx);

    // ─── 신고 처리 ────────────────────────────────────────────────

    /** 신고 전체 수 */
    int getReportCount(String statusFilter);

    /** 신고 목록 조회 */
    List<ReviewReportVO> getReportList(int numPerPage, int offset, String statusFilter);

    /**
     * 신고 블라인드 처리
     * - review_report.rr_status = 'BLINDED' + rr_admin_reply 저장
     * - 대상 review.v_active = 2 (블라인드)
     */
    int processReportBlind(String rr_idx, String v_idx, String adminReply);

    /**
     * 신고 반려 처리 (문제없음)
     * - review_report.rr_status = 'DISMISSED' + rr_admin_reply 저장
     */
    int processReportDismiss(String rr_idx, String adminReply);

    /** 특정 리뷰의 전체 신고 목록 조회 */
    List<ReviewReportVO> getReportsByRevIdx(String revIdx);

    /** 리뷰 삭제 (관련 답글 포함) */
    int deleteReview(String revIdx);

    /** 관리자 답글 수정 */
    int updateAdminReply(String revIdx, String replyContent);

    /** 관리자 답글 삭제 */
    int deleteAdminReply(String revIdx);
}
