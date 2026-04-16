package org.study.project05.reservation.user.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.reservation.user.vo.PaymentVO;

@Mapper
public interface PaymentMapper {

    /** 결제 정보 저장 */
    void insertPayment(PaymentVO vo);

    /** orderId로 결제 정보 조회 */
    PaymentVO selectByOrderId(String orderId);

    /** 결제 상태 변경 (DONE → CANCELED 등) */
    void updatePayStatus(@Param("orderId") String orderId,
                         @Param("payStatus") String payStatus);
}
