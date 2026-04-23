package org.study.project05.settings.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05.settings.vo.RefundPolicyVO;

import java.util.List;

@Mapper
public interface RefundPolicyMapper {
    List<RefundPolicyVO> selectAll();
    int insert(RefundPolicyVO vo);
    int update(RefundPolicyVO vo);
    int delete(int policyIdx);
    /** 남은 시간(분)에 맞는 환불율 조회 — hours_before 내림차순으로 가장 먼저 매칭되는 구간 */
    Integer selectRefundRate(int hoursLeft);
}
