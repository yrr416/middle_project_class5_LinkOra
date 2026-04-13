package org.study.project05.reservation.user.service;

import org.study.project05.reservation.user.vo.UserUserReservationVO;

import java.util.List;
import java.util.Map;

public interface ReservaionService {

    void reserve(UserReservationVO vo);

    List<UserReservationVO> getMyReservations(int userIdx);

    void cancelReservation(int reservIdx, int userIdx);

    List<Integer> getUnavailableSlots(int spaceIdx, String date);

    /** 날짜별 시간대(0~23)별 잔여 좌석 수 반환 — INDIVIDUAL 타입 전용 */
    Map<Integer, Integer> getRemainingSeats(int spaceIdx, String date, int maxCapacity);
}
