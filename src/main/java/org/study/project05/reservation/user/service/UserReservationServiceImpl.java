package org.study.project05.reservation.user.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.study.project05.reservation.user.mapper.UserReservationMapper;
import org.study.project05.reservation.user.vo.ReservationVO;
import org.study.project05.space.mapper.SpaceMapper;
import org.study.project05.space.vo.SpaceVO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Service
public class UserReservationServiceImpl implements ReservaionService {

    @Autowired
    private UserReservationMapper reservationMapper;

    @Autowired
    private SpaceMapper spaceMapper;

    private static final DateTimeFormatter FORM_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    private static final DateTimeFormatter DB_FMT   = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Transactional
    @Override
    public void reserve(ReservationVO vo) {
        SpaceVO space = spaceMapper.selectById(vo.getSpcIdx());

        // ① 인원 초과 체크
        int maxCapacity = Integer.parseInt(space.getSpcMaxCapacity());
        if (vo.getResHeadcount() > maxCapacity) {
            throw new IllegalArgumentException(
                    "예약 인원(" + vo.getResHeadcount() + "명)이 최대 수용 인원(" + maxCapacity + "명)을 초과했습니다."
            );
        }

        // 시간 파싱
        LocalDateTime start = LocalDateTime.parse(vo.getResStartTime(), FORM_FMT);
        LocalDateTime end   = LocalDateTime.parse(vo.getResEndTime(),   FORM_FMT);

        if (!end.isAfter(start)) {
            throw new IllegalArgumentException("종료 시간은 시작 시간보다 늦어야 합니다.");
        }

        // DB 저장용 포맷으로 변환
        vo.setResStartTime(start.format(DB_FMT));
        vo.setResEndTime(end.format(DB_FMT));

        // ② 시간 중복 체크
        if (reservationMapper.checkDuplicate(vo) > 0) {
            throw new IllegalArgumentException("선택한 시간대에 이미 예약이 존재합니다.");
        }

        // ③ 총액 계산
        long hours = ChronoUnit.HOURS.between(start, end);
        int price  = Integer.parseInt(space.getSpcPrice());
        int total;
        if ("INDIVIDUAL".equals(space.getSpcType())) {
            total = price * vo.getResHeadcount() * (int) hours;
        } else {
            total = price * (int) hours;
        }
        vo.setResTotalPrice(String.valueOf(total));

        // ④ INSERT
        reservationMapper.insert(vo);
    }

    @Override
    public List<ReservationVO> getMyReservations(int userIdx) {
        return reservationMapper.selectByUser(userIdx);
    }

    @Override
    public void cancelReservation(int resIdx, int userIdx) {
        reservationMapper.cancel(resIdx, userIdx);
    }

    @Override
    public List<Integer> getUnavailableSlots(int spaceIdx, String date) {
        List<ReservationVO> reservations = reservationMapper.getSlotsByDate(spaceIdx, date);
        Set<Integer> unavailable = new HashSet<>();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        for (ReservationVO r : reservations) {
            LocalDateTime start = LocalDateTime.parse(r.getResStartTime(), fmt);
            LocalDateTime end   = LocalDateTime.parse(r.getResEndTime(),   fmt);
            for (int h = start.getHour(); h < end.getHour(); h++) {
                unavailable.add(h);
            }
        }

        List<Integer> result = new ArrayList<>(unavailable);
        Collections.sort(result);
        return result;
    }

    @Override
    public Map<Integer, Integer> getRemainingSeats(int spaceIdx, String date, int maxCapacity) {
        List<ReservationVO> reservations = reservationMapper.getSlotsByDate(spaceIdx, date);
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        Map<Integer, Integer> bookedPerHour = new HashMap<>();
        for (ReservationVO r : reservations) {
            LocalDateTime start = LocalDateTime.parse(r.getResStartTime(), fmt);
            LocalDateTime end   = LocalDateTime.parse(r.getResEndTime(),   fmt);
            for (int h = start.getHour(); h < end.getHour(); h++) {
                bookedPerHour.merge(h, r.getResHeadcount(), Integer::sum);
            }
        }

        Map<Integer, Integer> remaining = new HashMap<>();
        for (int h = 0; h < 24; h++) {
            int booked = bookedPerHour.getOrDefault(h, 0);
            remaining.put(h, Math.max(0, maxCapacity - booked));
        }
        return remaining;
    }
}
