package org.study.project05.reservation.service;

import org.study.project05.reservation.vo.AdminReservationVO;

import java.util.List;
import java.util.Map;

public interface ReservationService {
    int getReservationCount(int offset, int numPerPage, AdminReservationVO searchVO);
    List<AdminReservationVO> getReservationList(int offset, int numPerPage, AdminReservationVO searchVO);
    AdminReservationVO getReservationDetail(int resIdx);
    List<AdminReservationVO> getSpaceListForFilter();
    Map<String, Integer> getStatusSummary(AdminReservationVO searchVO);
    List<AdminReservationVO> getRecentReservationsByUser(int userIdx, int resIdx);
    void confirmReservation(int resIdx);
    void completeReservation(int resIdx);
    void cancelReservation(int resIdx, String cancelReason);
}
