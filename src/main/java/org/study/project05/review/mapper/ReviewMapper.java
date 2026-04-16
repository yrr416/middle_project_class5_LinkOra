package org.study.project05.review.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.review.vo.ReviewVO;

import java.util.List;
@Mapper
public interface ReviewMapper {
    /** 지점의 최상위 후기 목록 (페이징) */
    List<ReviewVO> selectParentsByBranch(@Param("bIdx")   int bIdx,
                                         @Param("offset") int offset,
                                         @Param("limit")  int limit);

    /** 지점의 최상위 후기 총 개수 */
    int countParentsByBranch(int bIdx);

    /** 특정 후기의 답글 목록 */
    List<ReviewVO> selectRepliesByParent(int parentIdx);

    /** 지점 평균 별점 (최상위 후기만, 별점 0 제외) */
    double avgRatingByBranch(int bIdx);

    /** 본인 후기 삭제 (revIdx + userIdx 일치 시만 삭제) */
    int deleteByUser(@Param("revIdx") int revIdx, @Param("userIdx") int userIdx);

    /** 본인 후기 수정 (revIdx + userIdx 일치 시만 수정) */
    int updateByUser(ReviewVO vo);

    /** 후기/답글 등록 */
    void insert(ReviewVO vo);

    /** 리뷰 신고 저장 */
    void insertReport(@Param("vIdx") int vIdx,
                      @Param("userIdx") int userIdx,
                      @Param("reason") String reason);

    /** 동일 사용자가 해당 리뷰를 이미 신고했는지 확인 (1 = 이미 신고함) */
    int countReport(@Param("vIdx") int vIdx, @Param("userIdx") int userIdx);

    /* ===== 관리자 전용 ===== */

    /** 전체 리뷰 수 (검색어 포함) */
    int countAll(@Param("searchWord") String searchWord);

    /** 전체 리뷰 목록 (페이징 + 검색) */
    List<ReviewVO> selectAllForAdmin(@Param("searchWord") String searchWord,
                                     @Param("offset")     int    offset,
                                     @Param("limit")      int    limit);

    /** 관리자 리뷰 강제 삭제 */
    int deleteByAdmin(@Param("revIdx") int revIdx);
}
