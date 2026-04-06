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
    private Integer cIdx;       // 고유 번호
    private Long uIdx;          // 사용자 번호
    private Integer cSession;   // 대화 세션 ID
    private String cMessage;    // 사용자가 보낸 메시지
    private String cResponse;   // 봇이 응답한 내용
    private String cIntent;     // 대화 의도
    private String cPage;       // 발생한 페이지 위치
    private java.util.Date cTime; // 대화 기록 시간
}
