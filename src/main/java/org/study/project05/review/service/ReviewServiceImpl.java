package org.study.project05.review.service;

import org.study.project05.common.badword.BadWordFiltering;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.common.Paging;
import org.study.project05.review.mapper.ReviewMapper;
import org.study.project05.review.vo.ReviewVO;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewMapper reviewMapper;

    @Autowired
    private BadWordFiltering badWordFiltering;

    @Override
    public List<ReviewVO> getRecentReviews(int limit) {
        return reviewMapper.selectRecent(limit);
    }

    @Override
    public List<ReviewVO> getMyReviews(int userIdx) {
        return reviewMapper.selectByUser(userIdx);
    }

    @Override
    public Map<String, Object> getReviewPage(int bIdx, int page) {

        int total = reviewMapper.countParentsByBranch(bIdx);

        Paging paging = new Paging();
        int pagesize  = 5;
        int blocksize = 5;
        paging.setNumPerPage(pagesize);
        paging.setPagePerBlock(blocksize);
        paging.setTotalRecord(total);
        paging.setNowPage(page);

        if (total <= pagesize) {
            paging.setTotalPage(1);
        } else {
            int totalPage = total / pagesize;
            if (total % pagesize != 0) {
                paging.setTotalPage(++totalPage);
            } else {
                paging.setTotalPage(totalPage);
            }
        }

        paging.setOffset((paging.getNowPage() - 1) * paging.getNumPerPage());
        paging.setBeginBlock(((paging.getNowPage() - 1) / paging.getPagePerBlock()) * paging.getPagePerBlock() + 1);
        paging.setEndBlock(paging.getBeginBlock() + paging.getPagePerBlock() - 1);

        if (paging.getEndBlock() >= paging.getTotalPage()) {
            paging.setEndBlock(paging.getTotalPage());
        }

        List<ReviewVO> reviews = reviewMapper.selectParentsByBranch(bIdx, paging.getOffset(), pagesize);
        for (ReviewVO r : reviews) {
            r.setReplies(reviewMapper.selectRepliesByParent(r.getRevIdx()));
        }

        double avg = reviewMapper.avgRatingByBranch(bIdx);

        Map<String, Object> result = new HashMap<>();
        result.put("reviews",   reviews);
        result.put("paging",    paging);
        result.put("avgRating", Math.round(avg * 10.0) / 10.0);
        return result;
    }

    @Override
    public Map<String, Object> getAllReviewsPage(int page) {
        int pageSize = 9;
        int total = reviewMapper.countAllPublic();

        Paging paging = new Paging();
        paging.setNumPerPage(pageSize);
        paging.setPagePerBlock(5);
        paging.setTotalRecord(total);
        paging.setNowPage(page);

        if (total <= pageSize) {
            paging.setTotalPage(1);
        } else {
            int totalPage = total / pageSize;
            if (total % pageSize != 0) totalPage++;
            paging.setTotalPage(totalPage);
        }

        paging.setOffset((paging.getNowPage() - 1) * paging.getNumPerPage());
        paging.setBeginBlock(((paging.getNowPage() - 1) / paging.getPagePerBlock()) * paging.getPagePerBlock() + 1);
        paging.setEndBlock(paging.getBeginBlock() + paging.getPagePerBlock() - 1);
        if (paging.getEndBlock() >= paging.getTotalPage()) {
            paging.setEndBlock(paging.getTotalPage());
        }

        List<ReviewVO> reviews = reviewMapper.selectAllPublic(paging.getOffset(), pageSize);

        Map<String, Object> result = new HashMap<>();
        result.put("reviews", reviews);
        result.put("paging",  paging);
        result.put("total",   total);
        return result;
    }

    @Override
    public void writeReview(int spcIdx, int userIdx, String content, Integer rating, String imgUrl) {
        if (rating == null || rating < 1 || rating > 5) throw new IllegalArgumentException("별점은 1~5 사이여야 합니다.");
        if (content == null || content.isBlank()) throw new IllegalArgumentException("후기 내용을 입력해주세요.");

        // 이용 완료(FINISH) 예약이 있는 사람만 리뷰 작성 가능
        if (reviewMapper.countFinishedReservation(userIdx, spcIdx) == 0) {
            throw new IllegalArgumentException("해당 공간의 이용이 완료된 후에만 후기를 작성할 수 있습니다.");
        }

        // 욕설 필터 적용: 감지된 욕설을 *** 로 치환하여 저장
        // change(text, sings) : 단어 사이에 공백·특수문자가 끼어 있어도 감지 (예: "개 새끼", "개.새끼")
        String filtered = badWordFiltering.change(content.trim(),
                new String[]{" ", "　", ".", "!", "*", "-", "_", "~", "ㅡ"});

        ReviewVO vo = new ReviewVO();
        vo.setSpcIdx(spcIdx);
        vo.setUserIdx(userIdx);
        vo.setRevParentIdx(0);
        vo.setRevContent(filtered);
        vo.setRevRating(rating);
        vo.setRevImg(imgUrl);
        reviewMapper.insert(vo);
    }

    @Override
    public void updateReview(int revIdx, int userIdx, String content, Integer rating, String imgUrl) {
        if (rating == null || rating < 1 || rating > 5) throw new IllegalArgumentException("별점은 1~5 사이여야 합니다.");
        if (content == null || content.isBlank()) throw new IllegalArgumentException("후기 내용을 입력해주세요.");

        // 욕설 필터 적용 (writeReview와 동일한 방식)
        String filtered = badWordFiltering.change(content.trim(),
                new String[]{" ", "　", ".", "!", "*", "-", "_", "~", "ㅡ"});

        ReviewVO vo = new ReviewVO();
        vo.setRevIdx(revIdx);
        vo.setUserIdx(userIdx);
        vo.setRevContent(filtered);
        vo.setRevRating(rating);
        // imgUrl: null=기존 유지(SQL에서 제외), ""=삭제, 파일명=교체
        // → null 이외의 값만 세팅해야 SQL <if> 조건이 작동함
        if (imgUrl != null) {
            vo.setRevImg(imgUrl);
        }

        // updateByUser는 revIdx + userIdx 모두 일치할 때만 수정하고 영향받은 행 수를 반환
        int updated = reviewMapper.updateByUser(vo);
        if (updated == 0) {
            throw new IllegalArgumentException("수정 권한이 없거나 존재하지 않는 리뷰입니다.");
        }
    }

    @Override
    public void deleteReview(int revIdx, int userIdx) {
        // 삭제 전 이미지 파일명 조회 (DB 삭제 후에는 알 수 없으므로 먼저 조회)
        ReviewVO review = reviewMapper.selectOne(revIdx);

        // deleteByUser는 revIdx + userIdx가 모두 일치할 때만 삭제하고 영향받은 행 수를 반환
        // 0이면 본인 리뷰가 아니거나 이미 삭제된 것
        int deleted = reviewMapper.deleteByUser(revIdx, userIdx);
        if (deleted == 0) {
            throw new IllegalArgumentException("삭제 권한이 없거나 존재하지 않는 리뷰입니다.");
        }

        // DB 삭제 성공 시 첨부 이미지 파일도 서버에서 제거
        if (review != null && review.getRevImg() != null && !review.getRevImg().isBlank()) {
            File imgFile = new File("src/main/webapp/static/upload/review/" + review.getRevImg());
            if (imgFile.exists()) {
                imgFile.delete();
            }
        }
    }

    @Override
    public void reportReview(int revIdx, int userIdx, String reason) {
        if (reviewMapper.countReport(revIdx, userIdx) > 0) {
            throw new IllegalStateException("이미 신고한 후기입니다.");
        }
        reviewMapper.insertReport(revIdx, userIdx, reason);
    }

    @Override
    public void writeReply(int spcIdx, int revParentIdx, int userIdx, String content) {
        if (content == null || content.isBlank()) throw new IllegalArgumentException("답글 내용을 입력해주세요.");

        ReviewVO vo = new ReviewVO();
        vo.setSpcIdx(spcIdx);
        vo.setUserIdx(userIdx);
        vo.setRevParentIdx(revParentIdx);
        vo.setRevContent(content.trim());
        vo.setRevRating(0);
        reviewMapper.insert(vo);
    }
}
