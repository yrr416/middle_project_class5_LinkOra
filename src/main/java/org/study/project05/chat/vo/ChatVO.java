package org.study.project05.chat.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatVO {
    private Integer chatIdx;       // 고유 번호
    private Long userIdx;          // 사용자 번호
    private Integer chatSession;   // 대화 세션 ID
    private String chatMessage;    // 사용자가 보낸 메시지
    private String chatResponse;   // 봇이 응답한 내용
    private String chatIntent;     // 대화 의도
    private String chatPage;       // 발생한 페이지 위치
    private java.util.Date chatTime; // 대화 기록 시간
}
