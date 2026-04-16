package org.study.project05.chat.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.chat.vo.ChatVO;
import java.util.List;

@Mapper
public interface ChatMapper {
    /**
     * 새로운 챗봇 메시지 저장
     * @param chatVO 저장할 대화 정보
     * @return 성공 여부
     */
    int insertChat(ChatVO chatVO);

    List<ChatVO> selectChatListBySession(@Param("chatSession") int chatSession, 
                                         @Param("userIdx") Long userIdx, 
                                         @Param("httpSessionId") String httpSessionId);

    /**
     * 사용자별 최근 대화 내역 조회 (과거 이력 불러오기용)
     * @param userIdx 사용자 ID
     * @return 대화 리스트
     */
    List<ChatVO> selectRecentChatByUser(@Param("userIdx") Long userIdx);
}
