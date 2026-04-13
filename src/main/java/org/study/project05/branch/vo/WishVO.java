package org.study.project05.branch.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.fasterxml.jackson.annotation.JsonProperty;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WishVO {
    private Integer wishIdx;

    private Integer userIdx; // u_idx와 연결됨

    @JsonProperty("brnIdx") // JS에서 보내는 이름과 강제 매칭
    private Integer brnIdx; // b_idx와 연결됨

    private java.util.Date wishRegdate;
}