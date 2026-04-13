package org.study.project05.reservation.service;

import org.study.project05.reservation.vo.ReservationVO;

import java.util.List;
import java.util.Map;

public interface ReservationService {
    int getReservationCount(int offset, int numPerPage, ReservationVO searchVO);
    List<ReservationVO> getReservationList(int offset, int numPerPage, ReservationVO searchVO);
    ReservationVO getReservationDetail(int resIdx);
    List<ReservationVO> getSpaceListForFilter();
    Map<String, Integer> getStatusSummary(ReservationVO searchVO);
    List<ReservationVO> getRecentReservationsByUser(int userIdx, int resIdx);
    void confirmReservation(int resIdx);
    void completeReservation(int resIdx);
    void cancelReservation(int resIdx, String cancelReason);
}
