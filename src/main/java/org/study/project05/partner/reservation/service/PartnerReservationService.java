package org.study.project05.partner.reservation.service;

import org.study.project05.partner.reservation.vo.PartnerReservationVO;

import java.util.List;
import java.util.Map;

public interface PartnerReservationService {

    Map<String, Object> getSummary(int partnerIdx);

    int getCount(int partnerIdx, int offset, int numPerPage, PartnerReservationVO vo);

    List<PartnerReservationVO> getList(int partnerIdx, int offset, int numPerPage, PartnerReservationVO vo);

    /**
     * 예약 상세 조회. 파트너 소속이 아닌 예약이면 null 반환 (보안).
     */
    PartnerReservationVO getDetail(int resIdx, int partnerIdx);

    List<PartnerReservationVO> getSpaceList(int partnerIdx);

    List<Map<String, Object>> getCalendarEvents(int partnerIdx, int year, int month);

    /**
     * 정산/매출 데이터. keys: byDay, bySpace, totalRevenue, totalCnt, feeRevenue
     */
    /** periodType: "daily" | "weekly" | "monthly" */
    Map<String, Object> getRevenueData(int partnerIdx, String startDate, String endDate, String periodType);

    /** 예약 수락 (PENDING → CONFIRMED). 성공 여부 반환 */
    boolean confirmReservation(int resIdx, int partnerIdx);

    /**
     * 예약 수락 + 사용자 이메일 발송
     * confirmReservation() 성공 시 사용자에게 승인 안내 메일을 자동 발송한다.
     * 메일 발송 실패는 조용히 무시 (예약 승인은 이미 완료된 상태이므로 롤백 없음)
     */
    boolean confirmAndNotify(int resIdx, int partnerIdx);

    /** 예약 거절 (PENDING → CANCELLED). 성공 여부 반환 */
    boolean rejectReservation(int resIdx, int partnerIdx, String reason);
}
