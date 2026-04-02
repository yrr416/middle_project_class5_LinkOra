package org.study.midproject.chat.vo;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatVO {
    @JsonProperty("cidx")
    private Integer cIdx;       // 고유 번호
    
    @JsonProperty("uidx")
    private Integer uIdx;       // 사용자 번호
    
    @JsonProperty("csession")
    private Integer cSession;   // 대화 세션 ID
    
    @JsonProperty("cmessage")
    private String cMessage; // 사용자가 보낸 메시지
    
    @JsonProperty("cresponse")
    private String cResponse; // 봇이 응답한 내용
    
    @JsonProperty("cintent")
    private String cIntent;   // 대화 의도
    
    @JsonProperty("cpage")
    private String cPage;     // 발생한 페이지 위치
    
    @JsonProperty("ctime")
    private Date cTime;       // 대화 기록 시간
}
