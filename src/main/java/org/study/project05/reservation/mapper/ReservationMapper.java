package org.study.project05.reservation.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.reservation.vo.ReservationVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface ReservationMapper {

    int getReservationCount(Map<String, Object> params);
    List<ReservationVO> getReservationList(Map<String, Object> params);
    ReservationVO getReservationDetail(@Param("resIdx") int resIdx);
    List<ReservationVO> getSpaceListForFilter();
    List<Map<String, Object>> getStatusSummary(Map<String, Object> params);

    void confirmReservation(@Param("resIdx") int resIdx);
    void completeReservation(@Param("resIdx") int resIdx);
    void cancelReservation(Map<String, Object> params);
}
