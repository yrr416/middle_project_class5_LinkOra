package org.study.project05class.reservation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.study.project05class.reservation.mapper.ReservationMapper;
import org.study.project05class.reservation.vo.ReservationVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 예약 관리 서비스 구현체
 */
@Service
public class ReservationServiceImpl implements ReservationService {

    @Autowired
    private ReservationMapper reservationMapper;

    /* ── 목록 조회 ─────────────────────────────────────── */

    /** 필터·페이징 조건을 Map 으로 묶어 매퍼에 전달 — 전체 건수 */
    @Override
    public int getReservationCount(int offset, int numPerPage, ReservationVO searchVO) {
        Map<String, Object> params = buildParams(offset, numPerPage, searchVO);
        return reservationMapper.getReservationCount(params);
    }

    /** 필터·페이징 조건을 Map 으로 묶어 매퍼에 전달 — 예약 목록 */
    @Override
    public List<ReservationVO> getReservationList(int offset, int numPerPage, ReservationVO searchVO) {
        Map<String, Object> params = buildParams(offset, numPerPage, searchVO);
        return reservationMapper.getReservationList(params);
    }

    /* ── 상세 조회 ─────────────────────────────────────── */

    @Override
    public ReservationVO getReservationDetail(int r_idx) {
        return reservationMapper.getReservationDetail(r_idx);
    }

    /* ── 필터 드롭다운 ──────────────────────────────────── */

    @Override
    public List<ReservationVO> getSpaceListForFilter() {
        return reservationMapper.getSpaceListForFilter();
    }

    /* ── 상태별 건수 ────────────────────────────────────── */

    /**
     * DB 에서 상태별 건수 목록을 가져와 Map<상태코드, 건수> 로 변환
     * 상태 필터를 제외한 날짜·공간 조건만 적용하여 전체 현황을 보여 줌
     */
    @Override
    public Map<String, Integer> getStatusSummary(ReservationVO searchVO) {
        /* 상태 필터를 제외한 파라미터 맵 구성 */
        Map<String, Object> params = new HashMap<>();
        params.put("vo", searchVO);

        List<Map<String, Object>> rows = reservationMapper.getStatusSummary(params);

        /* 기본값 0 으로 초기화 */
        Map<String, Integer> summary = new HashMap<>();
        summary.put("PENDING",   0);
        summary.put("CONFIRMED", 0);
        summary.put("USING",     0);
        summary.put("COMPLETED", 0);
        summary.put("CANCELLED", 0);

        for (Map<String, Object> row : rows) {
            String status = (String) row.get("r_status");
            int    cnt    = ((Number) row.get("cnt")).intValue();
            summary.put(status, cnt);
        }
        return summary;
    }

    /* ── 상태 변경 ─────────────────────────────────────── */

    /** 예약 확정 (PENDING → CONFIRMED) */
    @Override
    public void confirmReservation(int r_idx) {
        reservationMapper.confirmReservation(r_idx);
    }

    /** 이용 완료 (CONFIRMED / USING → COMPLETED) */
    @Override
    public void completeReservation(int r_idx) {
        reservationMapper.completeReservation(r_idx);
    }

    /**
     * 강제 취소 처리
     * - r_status = 'CANCELLED' 로 변경
     * - 취소 사유를 r_content 에 저장 (별도 컬럼 없으므로 재사용)
     */
    @Override
    public void cancelReservation(int r_idx, String cancelReason) {
        Map<String, Object> params = new HashMap<>();
        params.put("r_idx",        r_idx);
        params.put("cancel_reason", cancelReason);
        reservationMapper.cancelReservation(params);
    }

    /* ── 내부 헬퍼 ─────────────────────────────────────── */

    /**
     * 매퍼에 전달할 공통 파라미터 Map 구성
     * (검색 VO + 페이징 수치를 하나의 맵으로 묶음)
     */
    private Map<String, Object> buildParams(int offset, int numPerPage, ReservationVO vo) {
        Map<String, Object> params = new HashMap<>();
        params.put("vo",         vo);
        params.put("offset",     offset);
        params.put("numPerPage", numPerPage);
        return params;
    }
}
