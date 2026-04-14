package org.study.project05.reservation.user.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.reservation.user.vo.ReservationVO;

import java.util.List;

// 관리자용 ReservationMapper와 빈 이름 충돌을 피하기 위해 UserReservationMapper로 명명
@Mapper
public interface UserReservationMapper {

    int checkDuplicate(ReservationVO vo);
    void insert(ReservationVO vo);
    List<ReservationVO> getSlotsByDate(@Param("spaceIdx") int spaceIdx, @Param("date") String date);

    /** 내 예약 목록 (공간명·지점명 JOIN) */
    List<ReservationVO> selectByUser(int userIdx);

    /** 예약 취소 (본인 예약만 — userIdx 검증 포함) */
    void cancel(@Param("resIdx") int resIdx, @Param("userIdx") int userIdx);

    /** 해당 지점에 완료/진행중 예약이 있는지 확인 */
    int countByUserAndBranch(@Param("userIdx") int userIdx, @Param("brnIdx") int brnIdx);

    /**
     * 결제 승인 시 사용 — 행 락(SELECT FOR UPDATE)을 걸고 예약 조회
     * 스케줄러의 자동 취소와 동시에 실행될 때 충돌을 방지함
     */
    ReservationVO selectByIdForUpdate(int rIdx);

    /** 예약 상태 변경 (PENDING → CONFIRMED / CANCELLED) */
    void updateStatus(@Param("rIdx") int rIdx, @Param("status") String status);

    /** 생성된 지 10분이 지난 PENDING 예약을 일괄 CANCELLED 처리 — 스케줄러 전용 */
    void cancelExpiredPending();
}

