package org.study.project05.reservation.user.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.study.project05.reservation.user.mapper.UserReservationMapper;
import org.study.project05.reservation.user.vo.UserReservationVO;
import org.study.project05.branch.mapper.BranchDetailSpaceMapper;
import org.study.project05.branch.vo.BranchSpaceVO;
import org.study.project05.settings.service.SettingsService;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Service
public class UserReservationServiceImpl implements UserReservationService {

    @Autowired
    private UserReservationMapper reservationMapper;

    @Autowired
    private BranchDetailSpaceMapper spaceMapper;

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private SettingsService settingsService;

    @Autowired
    private ReservationMailService mailService;
    //DB용 타임포멧과 자바에서 시간처리를 위한 타임포멧 사전 선언
    private static final DateTimeFormatter FORM_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    private static final DateTimeFormatter DB_FMT   = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Transactional
    @Override
    public void reserve(UserReservationVO vo) {
        BranchSpaceVO space = spaceMapper.selectById(vo.getSpcIdx());
        if (space == null) {
            throw new IllegalArgumentException("선택하신 공간 정보를 찾을 수 없습니다. (ID: " + vo.getSpcIdx() + ")");
        }

        // ① 인원 초과 체크 (spcMaxCapacity는 int 타입이므로 parseInt 불필요)
        int maxCapacity = space.getSpcMaxCapacity();
        if (vo.getResHeadcount() > maxCapacity) {
            throw new IllegalArgumentException(
                    "예약 인원(" + vo.getResHeadcount() + "명)이 최대 수용 인원(" + maxCapacity + "명)을 초과했습니다."
            );
        }

        // 시간 파싱 (공백이 포함된 경우 T로 치환하여 유연하게 대응)
        String startTimeStr = vo.getResStartTime().replace(" ", "T");
        String endTimeStr = vo.getResEndTime().replace(" ", "T");

        // 시간계산을 위한 객체로 변환
        LocalDateTime start = LocalDateTime.parse(startTimeStr, FORM_FMT);
        LocalDateTime end   = LocalDateTime.parse(endTimeStr, FORM_FMT);

        if (!end.isAfter(start)) {
            throw new IllegalArgumentException("종료 시간은 시작 시간보다 늦어야 합니다.");
        }

        // 현재 시각보다 과거인 예약 차단
        if (start.isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("현재 시각 이후로만 예약할 수 있습니다.");
        }

        // DB 저장용 포맷으로 변환
        vo.setResStartTime(start.format(DB_FMT));
        vo.setResEndTime(end.format(DB_FMT));

        // ② space 행 락 — 같은 공간에 동시 요청이 들어오면 여기서 대기시킴
        //    락을 잡은 뒤 중복 체크 → INSERT 까지 원자적으로 처리
        //    락 대기 중 타임아웃 발생 시(다른 트랜잭션이 너무 오래 점유) Exception으로 잡아 안내 메시지 표시
        try {
            reservationMapper.lockSpace(vo.getSpcIdx());
        } catch (Exception e) {
            throw new IllegalArgumentException("현재 다른 사용자가 예약 중입니다. 잠시 후 다시 시도해주세요.");
        }

        // ③ 시간 중복 체크 (락 획득 후 실행되므로 동시성 안전)
        if (reservationMapper.checkDuplicate(vo) > 0) {
            throw new IllegalArgumentException("선택한 시간대에 이미 예약이 존재합니다.");
        }

        // ③ 총액 계산 (spcPrice는 int 타입이므로 parseInt 불필요)
        long hours = ChronoUnit.HOURS.between(start, end);
        int price  = space.getSpcPrice();
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

    /** 내 예약 목록 */
    @Override
    public List<UserReservationVO> getMyReservations(int userIdx) {
        return reservationMapper.selectByUser(userIdx);
    }

    @Override
    public UserReservationVO getReservationById(int resIdx) {
        return reservationMapper.selectById(resIdx);
    }

    /** 예약 취소 — ONLINE 결제 완료(CONFIRMED) 예약은 환불율 계산 후 토스 환불 처리 + 취소 메일 발송 */
    @Transactional
    @Override
    public void cancelReservation(int resIdx, int userIdx, String email, String name) {
        UserReservationVO reservation = reservationMapper.selectById(resIdx);

        if (reservation != null
                && "ONLINE".equals(reservation.getPaymentType())
                && "CONFIRMED".equals(reservation.getResStatus())) {

            // 예약 시작까지 남은 시간 계산
            LocalDateTime startTime = LocalDateTime.parse(
                    reservation.getResStartTime().replace(" ", "T").substring(0, 16),
                    DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")
            );
            long hoursLeft = ChronoUnit.HOURS.between(LocalDateTime.now(), startTime);
            if (hoursLeft < 0) hoursLeft = 0;

            // 환불율 조회 → 환불 금액 계산
            int refundRate   = settingsService.getRefundRate((int) hoursLeft);
            int totalPrice   = Integer.parseInt(reservation.getResTotalPrice());
            int refundAmount = totalPrice * refundRate / 100;

            // 토스 환불 API 호출
            paymentService.cancelPayment(resIdx, refundAmount, "사용자 취소");

            // 취소 안내 메일 발송 (이메일 정보가 없으면 생략)
            if (email != null && !email.isBlank()) mailService.sendReservationCancelled(
                    email, name,
                    reservation.getSpaceName(),
                    reservation.getResStartTime(),
                    reservation.getResEndTime(),
                    totalPrice, refundAmount
            );
        }

        reservationMapper.cancel(resIdx, userIdx);
    }

    /** 특정 날짜의 점유된 시간(0~23) 목록 반환 - AJAX용 */
    @Override
    public List<Integer> getUnavailableSlots(int spaceIdx, String date) {
        List<UserReservationVO> reservations = reservationMapper.getSlotsByDate(spaceIdx, date);
        Set<Integer> unavailable = new HashSet<>();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        for (UserReservationVO r : reservations) {
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

    /** 해당 지점에 완료/진행중 예약이 있는지 확인 — 리뷰 작성 권한 체크용 */
    @Override
    public int countByUserAndBranch(int userIdx, int brnIdx) {
        return reservationMapper.countByUserAndBranch(userIdx, brnIdx);
    }

    /**
     * 날짜별 시간대(0~23)별 잔여 좌석 수 계산 — INDIVIDUAL 타입 전용
     *
     * 예) 10~12시 예약(3명)이 있고 maxCapacity=10 이면
     *     10시 → 잔여 7석, 11시 → 잔여 7석
     */
    @Override
    public Map<Integer, Integer> getRemainingSeats(int spaceIdx, String date, int maxCapacity) {
        List<UserReservationVO> reservations = reservationMapper.getSlotsByDate(spaceIdx, date);
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        // 시간대별 예약 인원 합산
        Map<Integer, Integer> bookedPerHour = new HashMap<>();
        for (UserReservationVO r : reservations) {
            LocalDateTime start = LocalDateTime.parse(r.getResStartTime(), fmt);
            LocalDateTime end   = LocalDateTime.parse(r.getResEndTime(),   fmt);
            for (int h = start.getHour(); h < end.getHour(); h++) {
                bookedPerHour.merge(h, r.getResHeadcount(), Integer::sum);
            }
        }

        // 잔여 좌석 = maxCapacity - 해당 시간대 예약 인원
        Map<Integer, Integer> remaining = new HashMap<>();
        for (int h = 0; h < 24; h++) {
            int booked = bookedPerHour.getOrDefault(h, 0);
            remaining.put(h, Math.max(0, maxCapacity - booked));
        }
        return remaining;
    }
}

