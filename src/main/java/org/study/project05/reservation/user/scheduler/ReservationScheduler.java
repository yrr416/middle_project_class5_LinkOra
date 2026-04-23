package org.study.project05.reservation.user.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.study.project05.reservation.user.mapper.UserReservationMapper;

@Component  // Spring이 이 클래스를 Bean으로 등록해서 @Scheduled가 동작하게 함
public class ReservationScheduler {

    @Autowired
    private UserReservationMapper reservationMapper;

    /**
     * 만료된 PENDING 예약 자동 취소
     *
     * fixedDelay = 60000 : 이전 실행이 완료된 후 1분 뒤에 다시 실행
     * (fixedRate와 달리 실행이 겹칠 위험이 없음)
     *
     * 동시성 처리:
     * 스케줄러가 CANCELLED로 UPDATE하는 행을 결제 승인이 동시에 건드리려 하면
     * SELECT FOR UPDATE 락 덕분에 둘 중 하나가 먼저 처리되고 나머지는 상태를 보고 포기함
     */
    @Scheduled(fixedDelay = 60000)
    @Transactional
    public void cancelExpiredPending() {
        reservationMapper.cancelExpiredPending();
    }
}
