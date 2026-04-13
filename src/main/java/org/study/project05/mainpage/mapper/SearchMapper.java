package org.study.project05.mainpage.mapper;

import org.study.project05.mainpage.vo.SearchLogVO;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

/**
 * 검색어 기록과 인기 검색어 조회를 담당하는 주문서(Mapper)임.
 */
@Mapper
public interface SearchMapper {

    // [이름 수정] XML의 id="recordKeyword"와 똑같이 맞췄음!
    void recordKeyword(String keyword);

    // [이름 확인] XML의 id="getTopKeywords"와 똑같이 맞췄음!
    List<SearchLogVO> getTopKeywords();
}