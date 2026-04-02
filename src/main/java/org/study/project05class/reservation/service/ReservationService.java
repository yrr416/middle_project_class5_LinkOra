package org.study.project05class.reservation.service;

import org.study.project05class.reservation.vo.ReservationVO;

import java.util.List;
import java.util.Map;

/**
 * 예약 관리 서비스 인터페이스
 */
public interface ReservationService {

    /** 전체 예약 건수 (필터 조건 적용) */
    int getReservationCount(int offset, int numPerPage, ReservationVO searchVO);

    /** 예약 목록 조회 (페이징 + 필터) */
    List<ReservationVO> getReservationList(int offset, int numPerPage, ReservationVO searchVO);

    /** 예약 상세 정보 단건 조회 */
    ReservationVO getReservationDetail(int r_idx);

    /** 공간 전체 목록 (필터 드롭다운용) */
    List<ReservationVO> getSpaceListForFilter();

    /**
     * 날짜·공간 필터만 적용한 상태별 건수
     * Map 키: PENDING, CONFIRMED, USING, COMPLETED, CANCELLED
     */
    Map<String, Integer> getStatusSummary(ReservationVO searchVO);

    /** 예약 확정 처리 */
    void confirmReservation(int r_idx);

    /** 이용 완료 처리 */
    void completeReservation(int r_idx);

    /** 강제 취소 처리 (취소 사유 함께 저장) */
    void cancelReservation(int r_idx, String cancelReason);
}
