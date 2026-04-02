package org.study.midproject.chat.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.midproject.chat.vo.ChatVO;
import java.util.List;

@Mapper
public interface ChatMapper {
    /**
     * 새로운 챗봇 메시지 저장
     * @param chatVO 저장할 대화 정보
     * @return 성공 여부
     */
    int insertChat(ChatVO chatVO);

    /**
     * 특정 사용자/세션의 대화 내역 조회
     * @param cSession 세션 ID
     * @return 대화 리스트
     */
    List<ChatVO> selectChatListBySession(int cSession);
}
