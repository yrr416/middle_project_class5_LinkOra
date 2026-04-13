package org.study.project05.mainpage.service;

import org.study.project05.mainpage.vo.SearchLogVO; // [확인] 가방 위치가 mainpage.vo 임을 확인했음.
import java.util.List;

/*
 인기 검색어 관련 기능의 규칙을 정하는 설계도임.
 */
public interface SearchService {

    // 검색어를 DB에 기록하거나 횟수를 올리는 규칙임.
    void recordKeyword(String keyword);

    // 가장 많이 검색된 단어 5개를 가져오는 규칙임.
    // 결과는 약속된 SearchLogVO 리스트로 돌려줌.
    List<SearchLogVO> getTopKeywords();
}