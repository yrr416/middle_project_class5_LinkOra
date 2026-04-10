package org.study.project05.branch.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data // 넣고 빼기 자동화임.
@NoArgsConstructor // 빈 가방임.
@AllArgsConstructor // 꽉 찬 가방임.
@Builder // 조립 로봇임.
public class SpaceVO {

    // 공간 번호표임 (s_idx).
    private int spcIdx;

    // 어느 지점에 있는지 알려줌 (b_idx).
    private int brnIdx;

    // 공간 종류임 (s_type, 오피스, 미팅룸 등).
    private String spcType;

    // 공간 이름임 (s_name).
    private String spcName;

    // 이용 가격임 (s_price).
    private int spcPrice;

    // 최대 들어갈 수 있는 사람 수임 (s_max_capacity).
    private int spcMaxCapacity;

    // 공간 설명글임 (s_description).
    private String spcDescription;

    // 공간 사진 파일 이름임 (s_img).
    private String spcImg;

    // 공간이 만들어진 시간임 (s_created).
    private LocalDateTime spcCreated;
}