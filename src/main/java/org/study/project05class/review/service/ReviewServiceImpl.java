package org.study.project05class.review.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05class.review.mapper.ReviewMapper;
import org.study.project05class.review.vo.ReviewReportVO;
import org.study.project05class.review.vo.ReviewVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 리뷰 관리 서비스 구현 클래스
 */
@Service
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewMapper reviewMapper;

    // ─── 리뷰 목록 ───────────────────────────────────────────────

    /** 전체 리뷰 수 (처리완료 v_active=1 제외, 원본 리뷰만) */
    @Override
    public int getReviewCount(ReviewVO reviewVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("reviewVO", reviewVO);
        return reviewMapper.getReviewCount(map);
    }

    /** 리뷰 목록 조회 */
    @Override
    public List<ReviewVO> getReviewList(int numPerPage, int offset, ReviewVO reviewVO) {
        Map<String, Object> map = new HashMap<>();
        map.put("numPerPage", numPerPage);
        map.put("offset", offset);
        map.put("reviewVO", reviewVO);
        return reviewMapper.getReviewList(map);
    }

    /** 리뷰 상세 단건 조회 */
    @Override
    public ReviewVO getReviewDetail(String v_idx) {
        return reviewMapper.getReviewDetail(v_idx);
    }

    // ─── 관리자 답글 ──────────────────────────────────────────────

    /**
     * 관리자 답글 등록
     * 1) 원본 리뷰 정보 조회 (s_idx 가져오기 위해)
     * 2) 답글 레코드 INSERT (v_parent_idx = 원본 v_idx, u_idx = 0 관리자)
     * - 원본 리뷰의 v_active는 변경하지 않음
     * - 답글(v_parent_idx != 0)이 존재하면 SQL의 NOT EXISTS 조건으로
     *   원본 리뷰가 관리자 페이지 목록에서 자동으로 숨겨짐
     */
    @Override
    public int insertAdminReply(String v_idx, String replyContent) {
        // 1) 원본 리뷰 조회 (s_idx 참조용)
        ReviewVO original = reviewMapper.getReviewDetail(v_idx);
        if (original == null) return 0;

        // 2) 답글 VO 구성 (u_idx=0 관리자, v_rating=0, v_parent_idx=원본 v_idx)
        ReviewVO reply = new ReviewVO();
        reply.setU_idx("0");                 // 관리자 답글 식별값 (0 = 관리자)
        reply.setS_idx(original.getS_idx()); // 동일 공간
        reply.setV_content(replyContent);    // 답글 내용
        reply.setV_parent_idx(v_idx);        // 원본 리뷰 번호 → 이 값이 존재하면 원본 리뷰 숨김
        reply.setV_rating("0");              // 답글은 별점 없음
        reply.setV_active("0");              // 답글 자체 상태 (v_active는 블라인드 전용으로만 사용)

        return reviewMapper.insertAdminReply(reply);
    }

    // ─── 블라인드 처리 ────────────────────────────────────────────

    /** 리뷰 블라인드 처리 (v_active = 2) */
    @Override
    public int blindReview(String v_idx) {
        Map<String, Object> map = new HashMap<>();
        map.put("v_idx", v_idx);
        map.put("v_active", "2");
        return reviewMapper.updateReviewActive(map);
    }

    /** 리뷰 블라인드 해제 (v_active = 0, 미처리 상태로 복귀) */
    @Override
    public int unblindReview(String v_idx) {
        Map<String, Object> map = new HashMap<>();
        map.put("v_idx", v_idx);
        map.put("v_active", "0");
        return reviewMapper.updateReviewActive(map);
    }

    // ─── 신고 처리 ────────────────────────────────────────────────

    /** 신고 전체 수 */
    @Override
    public int getReportCount(String statusFilter) {
        Map<String, Object> map = new HashMap<>();
        map.put("statusFilter", statusFilter);
        return reviewMapper.getReportCount(map);
    }

    /** 신고 목록 조회 */
    @Override
    public List<ReviewReportVO> getReportList(int numPerPage, int offset, String statusFilter) {
        Map<String, Object> map = new HashMap<>();
        map.put("numPerPage", numPerPage);
        map.put("offset", offset);
        map.put("statusFilter", statusFilter);
        return reviewMapper.getReportList(map);
    }

    /**
     * 신고 블라인드 처리
     * 1) review_report.rr_status = 'BLINDED' + 관리자 알림 메시지 저장
     * 2) 대상 review.v_active = 2 (블라인드)
     */
    @Override
    public int processReportBlind(String rr_idx, String v_idx, String adminReply) {
        // 1) 신고 상태 업데이트
        Map<String, Object> map = new HashMap<>();
        map.put("rr_idx", rr_idx);
        map.put("rr_status", "BLINDED");
        map.put("rr_admin_reply", adminReply);
        reviewMapper.updateReportStatus(map);

        // 2) 대상 리뷰 블라인드
        Map<String, Object> blindMap = new HashMap<>();
        blindMap.put("v_idx", v_idx);
        blindMap.put("v_active", "2");
        return reviewMapper.updateReviewActive(blindMap);
    }

    /**
     * 신고 반려 처리 (문제없음)
     * - review_report.rr_status = 'DISMISSED' + 관리자 알림 메시지 저장
     * - 리뷰 상태는 변경하지 않음
     */
    @Override
    public int processReportDismiss(String rr_idx, String adminReply) {
        Map<String, Object> map = new HashMap<>();
        map.put("rr_idx", rr_idx);
        map.put("rr_status", "DISMISSED");
        map.put("rr_admin_reply", adminReply);
        return reviewMapper.updateReportStatus(map);
    }
}
