package org.study.project05.review.service;

import org.study.project05.review.vo.ReviewVO;

import java.util.List;
import java.util.Map;

public interface ReviewService {

    Map<String, Object> getReviewPage(int bIdx, int page);

    /** 내가 쓴 리뷰 목록 */
    List<ReviewVO> getMyReviews(int userIdx);

    List<ReviewVO> getRecentReviews(int limit);

    /** 전체 공개 리뷰 페이징 목록 */
    Map<String, Object> getAllReviewsPage(int page);

    void writeReply(int spcIdx, int revParentIdx, Integer userIdx, String content);

    void writeReview(int spcIdx, int userIdx, String content, Integer rating, String imgUrl);

    /**
     * 본인 리뷰 삭제
     * @throws IllegalArgumentException 본인 리뷰가 아닌 경우
     */
    void deleteReview(int revIdx, int userIdx);

    /**
     * 본인 리뷰 수정 (욕설 필터 적용)
     * @param imgUrl null=기존 이미지 유지, ""=이미지 삭제, 파일명=새 이미지로 교체
     * @throws IllegalArgumentException 본인 리뷰가 아니거나 내용/별점이 유효하지 않은 경우
     */
    void updateReview(int revIdx, int userIdx, String content, Integer rating, String imgUrl);

    /**
     * 관리자 답글 삭제 (v_idx 기준, ROLE_ADMIN만 호출)
     * @throws IllegalArgumentException 존재하지 않거나 답글이 아닌 경우
     */
    void deleteAdminReply(int revIdx);

    /**
     * 관리자 답글 내용 수정 (u_idx IS NULL인 답글만)
     * @throws IllegalArgumentException 존재하지 않는 답글인 경우
     */
    void updateAdminReply(int revIdx, String content);

    /**
     * 리뷰 신고
     * @throws IllegalStateException 이미 신고한 경우
     */
    void reportReview(int revIdx, int userIdx, String reason);
}
