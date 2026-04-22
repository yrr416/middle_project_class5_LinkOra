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

    /** 메인 페이지용 최신 리뷰 N개 (전체 지점) */
    List<ReviewVO> selectRecent(@Param("limit") int limit);

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

    /** 관리자 리뷰 강제 삭제 전 신고 기록 삭제 */
    int deleteReportsByRevIdx(@Param("revIdx") int revIdx);

    /** 관리자 리뷰 강제 삭제 */
    int deleteByAdmin(@Param("revIdx") int revIdx);

    /** 내가 쓴 리뷰 목록 (userIdx 기준) */
    List<ReviewVO> selectByUser(@Param("userIdx") int userIdx);

    /** 해당 공간에 이용 완료(FINISH) 예약이 있는지 확인 */
    int countFinishedReservation(@Param("userIdx") int userIdx, @Param("spcIdx") int spcIdx);

    /** 전체 공개 리뷰 목록 (페이징, 별점 있는 최상위 후기만) */
    List<ReviewVO> selectAllPublic(@Param("offset") int offset, @Param("limit") int limit);

    /** 전체 공개 리뷰 수 */
    int countAllPublic();

    /** 리뷰 단건 조회 (삭제 전 이미지 파일명 확인용) */
    ReviewVO selectOne(@Param("revIdx") int revIdx);

    /** 관리자 답글 내용 수정 (v_idx + u_idx IS NULL 조건) */
    int updateAdminReply(@Param("revIdx") int revIdx, @Param("content") String content);

}
