package org.study.project05.review.service;

import java.util.Map;

public interface ReviewService {

    Map<String, Object> getReviewPage(int bIdx, int page);

    void writeReply(int spcIdx, int revParentIdx, int userIdx, String content);

    void writeReview(int spcIdx, int userIdx, String content, Integer rating, String imgUrl);

    /**
     * 본인 리뷰 삭제
     * @throws IllegalArgumentException 본인 리뷰가 아닌 경우
     */
    void deleteReview(int revIdx, int userIdx);

    /**
     * 본인 리뷰 수정 (욕설 필터 적용)
     * @throws IllegalArgumentException 본인 리뷰가 아니거나 내용/별점이 유효하지 않은 경우
     */
    void updateReview(int revIdx, int userIdx, String content, Integer rating);

    /**
     * 리뷰 신고
     * @throws IllegalStateException 이미 신고한 경우
     */
    void reportReview(int revIdx, int userIdx, String reason);
}
