package org.study.project05.reservation.user.service;

import org.study.project05.reservation.user.vo.ReservationVO;

import java.util.List;
import java.util.Map;

public interface UserReservationService {

    void reserve(ReservationVO vo);

    List<ReservationVO> getMyReservations(int userIdx);

    void cancelReservation(int reservIdx, int userIdx);

    List<Integer> getUnavailableSlots(int spaceIdx, String date);

    /** 날짜별 시간대(0~23)별 잔여 좌석 수 반환 — INDIVIDUAL 타입 전용 */
    Map<Integer, Integer> getRemainingSeats(int spaceIdx, String date, int maxCapacity);

    /** 해당 지점에 완료/진행중 예약이 있는지 확인 — 리뷰 작성 권한 체크용 */
    int countByUserAndBranch(int userIdx, int brnIdx);
}
