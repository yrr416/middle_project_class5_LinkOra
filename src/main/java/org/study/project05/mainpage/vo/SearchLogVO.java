package org.study.project05.mainpage.vo; // 인기 검색어 가방도 branch 패키지의 vo로 옮겨줌.

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 인기 검색어 정보를 담는 가방임.
 */
@Data // 게터, 세터 등을 자동으로 만들어줌.
@NoArgsConstructor // 빈 가방을 만들 수 있게 함.
@AllArgsConstructor // 모든 내용이 찬 가방을 만들 수 있게 함.
@Builder // 가방을 조립해서 만들 수 있게 함.
public class SearchLogVO {

    // 검색된 단어 이름임 (keyword).
    private String keyword;

    // 이 단어가 몇 번이나 검색되었는지 나타내는 숫자임 (hit_count -> hitCount).
    private int hitCount;

}