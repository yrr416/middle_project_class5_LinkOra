package org.study.project05.contact.vo;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 장기 계약 문의 VO
 * contact 테이블과 매핑
 */
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ContactVO {

    private int    cntIdx;       // 문의 번호 (PK)
    private int    brnIdx;       // 문의 대상 지점 번호
    private int    userIdx;      // 문의한 사용자 번호

    private String cntStartDate; // 희망 시작일 (YYYY-MM-DD)
    private String cntDuration;  // 계약 기간 (예: "1개월", "3개월", "6개월", "1년")
    private int    cntHeadcount; // 인원 수
    private String cntContent;   // 문의 내용

    /** 문의 상태: PENDING(접수) / REPLIED(답변 완료) / CLOSED(종료) */
    private String cntStatus;

    private Date   cntCreatedAt; // DB의 ct_created_at (포맷은 JSP에서 처리)

    // ── JOIN 필드 (관리자 목록 조회 시 사용) ──
    private String branchName;   // 지점명
    private String userName;     // 문의자 이름
}
