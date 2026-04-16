package org.study.project05.reservation.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.reservation.vo.AdminReservationVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface ReservationMapper {

    int getReservationCount(Map<String, Object> params);
    List<AdminReservationVO> getReservationList(Map<String, Object> params);
    AdminReservationVO getReservationDetail(@Param("resIdx") int resIdx);
    List<AdminReservationVO> getSpaceListForFilter();
    List<Map<String, Object>> getStatusSummary(Map<String, Object> params);

    List<AdminReservationVO> getRecentReservationsByUser(Map<String, Object> params);

    void confirmReservation(@Param("resIdx") int resIdx);
    void completeReservation(@Param("resIdx") int resIdx);
    void cancelReservation(Map<String, Object> params);
}
