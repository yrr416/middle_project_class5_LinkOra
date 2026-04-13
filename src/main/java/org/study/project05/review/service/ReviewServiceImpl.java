package org.study.project05.review.service;

import org.study.project05.common.badword.BadWordFiltering;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.common.Paging;
import org.study.project05.review.mapper.ReviewMapper;
import org.study.project05.review.vo.ReviewVO;

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
    public void writeReview(int spcIdx, int userIdx, String content, Integer rating) {
        if (rating == null || rating < 1 || rating > 5) throw new IllegalArgumentException("별점은 1~5 사이여야 합니다.");
        if (content == null || content.isBlank()) throw new IllegalArgumentException("후기 내용을 입력해주세요.");

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
        reviewMapper.insert(vo);
    }

    @Override
    public void deleteReview(int revIdx, int userIdx) {
        // deleteByUser는 revIdx + userIdx가 모두 일치할 때만 삭제하고 영향받은 행 수를 반환
        // 0이면 본인 리뷰가 아니거나 이미 삭제된 것
        int deleted = reviewMapper.deleteByUser(revIdx, userIdx);
        if (deleted == 0) {
            throw new IllegalArgumentException("삭제 권한이 없거나 존재하지 않는 리뷰입니다.");
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
