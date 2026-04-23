package org.study.project05.reservation.user.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Service;

import java.util.Locale;
import java.util.Properties;

@Service
public class ReservationMailServiceImpl implements ReservationMailService {

    private static final Logger log = LoggerFactory.getLogger(ReservationMailServiceImpl.class);

    // true 로 설정하면 실제 메일 발송 없이 로그만 출력 (개발/테스트 시 편리)
    @Value("${app.mail.mock-enabled:false}")
    private boolean mockEnabled;

    @Value("${app.mail.from:no-reply@linkora.local}")
    private String fromAddress;

    @Value("${spring.mail.username:}")
    private String mailUsername;

    @Value("${spring.mail.password:}")
    private String mailPassword;

    @Value("${spring.mail.host:}")
    private String mailHost;

    @Value("${spring.mail.port:0}")
    private int mailPort;

    @Override
    public void sendReservationConfirm(String toEmail, String name,
                                       String spaceName,
                                       String startTime, String endTime,
                                       int amount) {
        // mock 모드: 실제 발송 없이 로그로 확인
        if (mockEnabled) {
            log.info("[MAIL MOCK] 예약확인 to={}, name={}, space={}, {}~{}, {}원",
                    toEmail, name, spaceName, startTime, endTime, amount);
            return;
        }

        // 메일 설정이 없으면 조용히 스킵 (결제는 이미 성공했으므로 메일 실패로 롤백 방지)
        if (mailUsername == null || mailUsername.isBlank()
                || mailPassword == null || mailPassword.isBlank()) {
            log.warn("[MAIL] 메일 설정이 없어 발송을 건너뜁니다.");
            return;
        }

        try {
            String displayName = (name == null || name.isBlank()) ? "고객" : name.trim();

            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(resolveFromAddress());
            message.setTo(toEmail);
            message.setSubject("[LinkOra] 예약이 확정되었습니다");
            message.setText(
                    displayName + "님, 안녕하세요.\n\n"
                    + "예약이 정상적으로 완료되었습니다.\n\n"
                    + "━━━━━━━━━━━━━━━━━━━━\n"
                    + "공간명  : " + spaceName + "\n"
                    + "시작    : " + startTime + "\n"
                    + "종료    : " + endTime   + "\n"
                    + "결제금액: " + String.format("%,d", amount) + "원\n"
                    + "━━━━━━━━━━━━━━━━━━━━\n\n"
                    + "이용해 주셔서 감사합니다.\n"
                    + "본 메일은 발신 전용입니다."
            );

            createSender().send(message);
            log.info("[MAIL] 예약확인 메일 발송 완료 → {}", toEmail);

        } catch (Exception e) {
            // 메일 발송 실패해도 결제/예약은 이미 완료된 상태이므로 예외를 던지지 않음
            log.error("[MAIL] 예약확인 메일 발송 실패 → {}, 사유: {}", toEmail, e.getMessage());
        }
    }

    @Override
    public void sendReservationApproved(String toEmail, String name,
                                        String spaceName,
                                        String startTime, String endTime) {
        if (mockEnabled) {
            log.info("[MAIL MOCK] 예약승인 to={}, name={}, space={}, {}~{}",
                    toEmail, name, spaceName, startTime, endTime);
            return;
        }

        if (mailUsername == null || mailUsername.isBlank()
                || mailPassword == null || mailPassword.isBlank()) {
            log.warn("[MAIL] 메일 설정이 없어 발송을 건너뜁니다.");
            return;
        }

        try {
            String displayName = (name == null || name.isBlank()) ? "고객" : name.trim();

            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(resolveFromAddress());
            message.setTo(toEmail);
            message.setSubject("[LinkOra] 예약이 승인되었습니다");
            message.setText(
                    displayName + "님, 안녕하세요.\n\n"
                    + "관리자가 예약을 승인하였습니다.\n\n"
                    + "━━━━━━━━━━━━━━━━━━━━\n"
                    + "공간명  : " + spaceName + "\n"
                    + "시작    : " + startTime + "\n"
                    + "종료    : " + endTime   + "\n"
                    + "━━━━━━━━━━━━━━━━━━━━\n\n"
                    + "이용해 주셔서 감사합니다.\n"
                    + "본 메일은 발신 전용입니다."
            );

            createSender().send(message);
            log.info("[MAIL] 예약승인 메일 발송 완료 → {}", toEmail);

        } catch (Exception e) {
            log.error("[MAIL] 예약승인 메일 발송 실패 → {}, 사유: {}", toEmail, e.getMessage());
        }
    }

    @Override
    public void sendReservationCancelled(String toEmail, String name,
                                         String spaceName,
                                         String startTime, String endTime,
                                         int paidAmount, int refundAmount) {
        if (mockEnabled) {
            log.info("[MAIL MOCK] 예약취소 to={}, name={}, space={}, 결제={}, 환불={}",
                    toEmail, name, spaceName, paidAmount, refundAmount);
            return;
        }

        if (mailUsername == null || mailUsername.isBlank()
                || mailPassword == null || mailPassword.isBlank()) {
            log.warn("[MAIL] 메일 설정이 없어 발송을 건너뜁니다.");
            return;
        }

        try {
            String displayName = (name == null || name.isBlank()) ? "고객" : name.trim();
            String refundLine  = refundAmount > 0
                    ? "환불금액: " + String.format("%,d", refundAmount) + "원 (영업일 기준 3~5일 내 처리)\n"
                    : "환불금액: 환불 불가 (취소 정책에 따라 환불되지 않습니다)\n";

            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(resolveFromAddress());
            message.setTo(toEmail);
            message.setSubject("[LinkOra] 예약이 취소되었습니다");
            message.setText(
                    displayName + "님, 안녕하세요.\n\n"
                    + "예약이 취소되었습니다.\n\n"
                    + "━━━━━━━━━━━━━━━━━━━━\n"
                    + "공간명  : " + spaceName + "\n"
                    + "시작    : " + startTime + "\n"
                    + "종료    : " + endTime   + "\n"
                    + "결제금액: " + String.format("%,d", paidAmount) + "원\n"
                    + refundLine
                    + "━━━━━━━━━━━━━━━━━━━━\n\n"
                    + "문의사항이 있으시면 고객센터로 연락 주세요.\n"
                    + "본 메일은 발신 전용입니다."
            );

            createSender().send(message);
            log.info("[MAIL] 예약취소 메일 발송 완료 → {}", toEmail);

        } catch (Exception e) {
            log.error("[MAIL] 예약취소 메일 발송 실패 → {}, 사유: {}", toEmail, e.getMessage());
        }
    }

    /**
     * JavaMailSender 생성 — 이메일 도메인으로 SMTP 서버 자동 감지
     * Gmail, 네이버, 다음, 네이트, Outlook, iCloud 지원
     */
    private JavaMailSenderImpl createSender() {
        MailProviderConfig provider = resolveProvider();
        JavaMailSenderImpl sender = new JavaMailSenderImpl();
        sender.setHost(provider.host());
        sender.setPort(provider.port());
        sender.setUsername(mailUsername.trim());
        sender.setPassword(mailPassword.trim());
        sender.setDefaultEncoding("UTF-8");

        Properties props = sender.getJavaMailProperties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", String.valueOf(provider.startTls()));
        props.put("mail.smtp.starttls.required", String.valueOf(provider.startTls()));
        props.put("mail.smtp.ssl.enable", String.valueOf(provider.ssl()));
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");
        return sender;
    }

    private String resolveFromAddress() {
        if (fromAddress != null && !fromAddress.isBlank() && !fromAddress.contains("${")) {
            return fromAddress.trim();
        }
        return mailUsername.trim();
    }

    private MailProviderConfig resolveProvider() {
        if (mailHost != null && !mailHost.isBlank()) {
            int port = mailPort > 0 ? mailPort : 587;
            boolean ssl = port == 465;
            return new MailProviderConfig(mailHost.trim(), port, !ssl, ssl);
        }
        String domain = extractDomain(mailUsername);
        return switch (domain) {
            case "gmail.com", "googlemail.com" -> new MailProviderConfig("smtp.gmail.com",       587, true,  false);
            case "naver.com"                   -> new MailProviderConfig("smtp.naver.com",        587, true,  false);
            case "daum.net", "hanmail.net"     -> new MailProviderConfig("smtp.daum.net",         465, false, true);
            case "nate.com"                    -> new MailProviderConfig("smtp.nate.com",         465, false, true);
            case "outlook.com", "hotmail.com",
                 "live.com", "office365.com"   -> new MailProviderConfig("smtp.office365.com",   587, true,  false);
            case "icloud.com", "me.com",
                 "mac.com"                     -> new MailProviderConfig("smtp.mail.me.com",     587, true,  false);
            default -> throw new IllegalStateException("지원하지 않는 메일 도메인입니다: " + domain);
        };
    }

    private static String extractDomain(String email) {
        if (email == null) return "";
        int at = email.indexOf('@');
        if (at < 0 || at + 1 >= email.length()) return "";
        return email.substring(at + 1).toLowerCase(Locale.ROOT).trim();
    }

    private record MailProviderConfig(String host, int port, boolean startTls, boolean ssl) {}
}
