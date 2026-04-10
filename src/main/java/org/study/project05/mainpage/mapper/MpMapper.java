package org.study.project05.mainpage.mapper;

import org.apache.ibatis.annotations.Mapper;

//메인 페이지 등 공통 기능을 처리할 주문서임.
@Mapper
public interface MpMapper {

    // [작동] 메인 화면에 띄울 최신 공지사항/이벤트 몇 개를 가져옴.
    // (NoticeVO는 조원분이 만든 VO 이름을 써야 함. 임시로 NoticeVO라고 적음)
    // List<NoticeVO> getRecentNotices();

    // [작동] 메인 화면 슬라이더에 띄울 베스트 리뷰들을 가져옴.
    // (ReviewVO도 조원분이 만든 VO 이름을 써야 함)
    // List<ReviewVO> getBestReviews();

    // [지도 안내] 아직 조원들이 NoticeVO랑 ReviewVO를 안 만들었다면,
    // 이 부분은 주석( // ) 처리해두고 나중에 합칠 때 풀면 됨!
}