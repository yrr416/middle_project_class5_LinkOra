package org.study.project05.mainpage.service;

import org.study.project05.mainpage.vo.SearchLogVO;
import org.study.project05.mainpage.mapper.SearchMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/*
 * SearchService 규칙을 실제로 수행하는 클래스임.
 */
@Service
@RequiredArgsConstructor
public class SearchServiceImpl implements SearchService {

    // DB 요리사인 Mapper를 불러옴.
    private final SearchMapper searchMapper;

    // 검색어를 기록하는 기능을 실제로 만듦.
    @Override
    public void recordKeyword(String keyword) {
        // 검색어가 비어있지 않을 때만 DB에 기록함.
        if (keyword != null && !keyword.trim().isEmpty()) {
            // [수정] Mapper 인터페이스 및 XML ID와 이름을 똑같이 맞췄음!
            searchMapper.recordKeyword(keyword);
        }
    }

    // 인기 검색어 리스트를 가져오는 기능을 실제로 만듦.
    @Override
    public List<SearchLogVO> getTopKeywords() {
        // DB 요리사에게 상위 5개를 가져오라고 시킴.
        return searchMapper.getTopKeywords();
    }
}