package org.study.project05.reservation.user.service;

import org.study.project05.reservation.user.vo.UserReservationVO;
import java.util.List;
import java.util.Map;

/**
 * UserReservationService - 사용자 예약 관련 비즈니스 로직 인터페이스
 * 기존 ReservaionService의 오타를 수정하고 표준 명칭을 사용합니다.
 */
public interface UserReservationService {

    void reserve(UserReservationVO vo);

    List<UserReservationVO> getMyReservations(int userIdx);

    List<UserReservationVO> getMyReservationsPaged(int userIdx, int page, int pageSize);

    int getMyReservationsCount(int userIdx);

    void cancelReservation(int resIdx, int userIdx, String email, String name);

    List<Integer> getUnavailableSlots(int spaceIdx, String date);

    /** 날짜별 시간대(0~23)별 잔여 좌석 수 반환 — INDIVIDUAL 타입 전용 */
    Map<Integer, Integer> getRemainingSeats(int spaceIdx, String date, int maxCapacity);

    /** 해당 지점에 완료/진행중 예약이 있는지 확인 — 리뷰 작성 권한 체크용 */
    int countByUserAndBranch(int userIdx, int brnIdx);

    /** 예약 단건 조회 */
    UserReservationVO getReservationById(int resIdx);
    
    /** 결제 수단 업데이트 */
    void updatePaymentType(int resIdx, String type);
}
