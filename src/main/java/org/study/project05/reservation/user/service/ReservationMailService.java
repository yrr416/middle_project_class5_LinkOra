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

    /**
     * 관리자 승인 시 사용자에게 발송하는 예약 승인 안내 메일
     * — 결제 없이 관리자가 수동 승인하는 방식에서 호출
     *
     * 팀원 사용법 (관리자 승인 컨트롤러에서):
     *   mailService.sendReservationApproved(email, name, spaceName, startTime, endTime);
     *
     * @param toEmail   수신자 이메일
     * @param name      수신자 이름
     * @param spaceName 예약 공간명
     * @param startTime 예약 시작 시간
     * @param endTime   예약 종료 시간
     */
    void sendReservationApproved(String toEmail, String name,
                                 String spaceName,
                                 String startTime, String endTime);

    /**
     * ONLINE 결제 예약 취소 안내 메일
     *
     * @param refundAmount 환불 금액 (0이면 환불 없음)
     */
    void sendReservationCancelled(String toEmail, String name,
                                  String spaceName,
                                  String startTime, String endTime,
                                  int paidAmount, int refundAmount);
}
