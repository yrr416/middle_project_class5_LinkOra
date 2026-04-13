package org.study.project05.partner.reservation.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.partner.reservation.vo.PartnerReservationVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface PartnerReservationMapper {

    Map<String, Object> getSummary(@Param("partnerIdx") int partnerIdx);

    int getCount(Map<String, Object> params);

    List<PartnerReservationVO> getList(Map<String, Object> params);

    PartnerReservationVO getDetail(Map<String, Object> params);

    List<PartnerReservationVO> getSpaceList(@Param("partnerIdx") int partnerIdx);

    List<Map<String, Object>> getCalendarEvents(Map<String, Object> params);

    List<Map<String, Object>> getRevenueByDay(Map<String, Object> params);
    List<Map<String, Object>> getRevenueByWeek(Map<String, Object> params);
    List<Map<String, Object>> getRevenueByMonth(Map<String, Object> params);

    List<Map<String, Object>> getRevenueBySpace(Map<String, Object> params);

    /** PENDING → CONFIRMED. 파트너 소유 검증 포함. 반환값: 변경된 행 수 */
    int confirmReservation(Map<String, Object> params);

    /** PENDING → CANCELLED. 파트너 소유 검증 포함. 반환값: 변경된 행 수 */
    int rejectReservation(Map<String, Object> params);
}
