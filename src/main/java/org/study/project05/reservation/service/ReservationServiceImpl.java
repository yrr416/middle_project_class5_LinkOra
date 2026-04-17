package org.study.project05.reservation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05.reservation.mapper.ReservationMapper;
import org.study.project05.reservation.vo.AdminReservationVO;

import java.util.*;

@Service
public class ReservationServiceImpl implements ReservationService {

    @Autowired
    private ReservationMapper reservationMapper;

    private Map<String, Object> buildParams(int offset, int numPerPage, AdminReservationVO vo) {
        Map<String, Object> p = new HashMap<>();
        p.put("vo", vo); p.put("offset", offset); p.put("numPerPage", numPerPage);
        return p;
    }

    @Override public int getReservationCount(int offset, int numPerPage, AdminReservationVO vo) {
        return reservationMapper.getReservationCount(buildParams(offset, numPerPage, vo));
    }
    @Override public List<AdminReservationVO> getReservationList(int offset, int numPerPage, AdminReservationVO vo) {
        return reservationMapper.getReservationList(buildParams(offset, numPerPage, vo));
    }
    @Override public AdminReservationVO getReservationDetail(int resIdx) {
        return reservationMapper.getReservationDetail(resIdx);
    }
    @Override public List<AdminReservationVO> getSpaceListForFilter() {
        return reservationMapper.getSpaceListForFilter();
    }
    @Override public Map<String, Integer> getStatusSummary(AdminReservationVO vo) {
        Map<String, Object> p = new HashMap<>(); p.put("vo", vo);
        List<Map<String, Object>> rows = reservationMapper.getStatusSummary(p);
        Map<String, Integer> result = new HashMap<>();
        for (String s : List.of("PENDING","CONFIRMED","USE","FINISH","CANCELLED")) result.put(s, 0);
        for (Map<String, Object> r : rows)
            result.put((String) r.get("resStatus"), ((Number) r.get("cnt")).intValue());
        return result;
    }
    @Override public List<AdminReservationVO> getRecentReservationsByUser(int userIdx, int resIdx) {
        Map<String, Object> p = new HashMap<>();
        p.put("userIdx", userIdx); p.put("resIdx", resIdx);
        return reservationMapper.getRecentReservationsByUser(p);
    }
    @Override public void confirmReservation(int resIdx) { reservationMapper.confirmReservation(resIdx); }
    @Override public void completeReservation(int resIdx) { reservationMapper.completeReservation(resIdx); }
    @Override public void cancelReservation(int resIdx, String reason) {
        Map<String, Object> p = new HashMap<>();
        p.put("resIdx", resIdx); p.put("cancelReason", reason);
        reservationMapper.cancelReservation(p);
    }
}
