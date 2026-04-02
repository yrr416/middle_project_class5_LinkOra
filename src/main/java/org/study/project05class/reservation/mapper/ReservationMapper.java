package org.study.project05class.reservation.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.study.project05class.reservation.vo.ReservationVO;

import java.util.List;
import java.util.Map;

/**
 * 예약 관리 매퍼
 * SQL 정의: resources/mapper/ReservationMapper.xml
 */
@Mapper
public interface ReservationMapper {

    /* ── 목록 조회 ─────────────────────────────────────── */

    /** 전체 예약 건수 (필터 조건 적용) — 페이징 총 건수 계산용 */
    int getReservationCount(Map<String, Object> params);

    /** 예약 목록 조회 (페이징 + 필터) */
    List<ReservationVO> getReservationList(Map<String, Object> params);

    /* ── 상세 조회 ─────────────────────────────────────── */

    /** 예약 상세 정보 단건 조회 (모달 데이터) */
    ReservationVO getReservationDetail(int r_idx);

    /* ── 필터 드롭다운용 ────────────────────────────────── */

    /** 공간 전체 목록 (공간별 필터 드롭다운, s_idx + s_name 만 사용) */
    List<ReservationVO> getSpaceListForFilter();

    /* ── 상태별 건수 (통계 카드용) ──────────────────────── */

    /**
     * 날짜 범위·공간 필터만 적용한 상태별 예약 건수
     * 반환 맵 키: r_status(String), cnt(Long)
     * — 상태 필터를 제외하여 필터 적용 중에도 전체 현황 카드를 보여 줌
     */
    List<Map<String, Object>> getStatusSummary(Map<String, Object> params);

    /* ── 상태 변경 ─────────────────────────────────────── */

    /** 예약 확정 (PENDING → CONFIRMED) */
    void confirmReservation(int r_idx);

    /** 이용 완료 처리 (CONFIRMED / USING → COMPLETED) */
    void completeReservation(int r_idx);

    /**
     * 강제 취소 (→ CANCELLED)
     * - r_content 에 취소 사유 저장
     * - r_updated 갱신
     */
    void cancelReservation(Map<String, Object> params);
}
