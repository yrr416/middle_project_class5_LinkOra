package org.study.project05.review.service;

import java.util.Map;

public interface ReviewService {

    Map<String, Object> getReviewPage(int bIdx, int page);

    void writeReply(int spcIdx, int revParentIdx, int userIdx, String content);

    void writeReview(int spcIdx, int userIdx, String content, Integer rating);

    /**
     * 본인 리뷰 삭제
     * @throws IllegalArgumentException 본인 리뷰가 아닌 경우
     */
    void deleteReview(int revIdx, int userIdx);

    /**
     * 리뷰 신고
     * @throws IllegalStateException 이미 신고한 경우
     */
    void reportReview(int revIdx, int userIdx, String reason);
}
