package org.study.project05.reservation.user.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.study.project05.reservation.user.vo.ReservationVO;

import java.util.List;

@Mapper
public interface UserReservationMapper {

    int checkDuplicate(ReservationVO vo);
    void insert(ReservationVO vo);
    List<ReservationVO> getSlotsByDate(@Param("spaceIdx") int spaceIdx, @Param("date") String date);

    /** 내 예약 목록 (공간명·지점명 JOIN) */
    List<ReservationVO> selectByUser(int userIdx);

    /** 예약 취소 (본인 예약만 — userIdx 검증 포함) */
    void cancel(@Param("resIdx") int resIdx, @Param("userIdx") int userIdx);
}
