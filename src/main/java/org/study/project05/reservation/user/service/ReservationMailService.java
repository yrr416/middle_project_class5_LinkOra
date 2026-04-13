package org.study.project05.reservation.user.service;

public interface ReservationMailService {

    /**
     * 결제 완료 후 예약 확인 메일 발송
     *
     * @param toEmail   수신자 이메일
     * @param name      수신자 이름
     * @param spaceName 예약 공간명
     * @param startTime 예약 시작 시간
     * @param endTime   예약 종료 시간
     * @param amount    결제 금액
     */
    void sendReservationConfirm(String toEmail, String name,
                                String spaceName,
                                String startTime, String endTime,
                                int amount);
}
