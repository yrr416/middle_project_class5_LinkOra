package org.study.project05.signup.service.impl;

import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Service;
import org.study.project05.signup.service.SignupEmailVerificationService;

import java.security.SecureRandom;
import java.util.Locale;
import java.util.Properties;

@Service
public class SignupEmailVerificationServiceImpl implements SignupEmailVerificationService {

    private static final Logger log = LoggerFactory.getLogger(SignupEmailVerificationServiceImpl.class);

    private static final String ATTR_EMAIL = "signupEmailVerify.email";
    private static final String ATTR_CODE = "signupEmailVerify.code";
    private static final String ATTR_EXPIRES_AT = "signupEmailVerify.expiresAt";
    private static final String ATTR_VERIFIED_EMAIL = "signupEmailVerify.verifiedEmail";
    private static final String ATTR_LAST_SENT_AT = "signupEmailVerify.lastSentAt";
    private static final String ATTR_FAIL_COUNT = "signupEmailVerify.failCount";
    private static final String ATTR_LOCKED = "signupEmailVerify.locked";

    private static final long EXPIRE_MILLIS = 5 * 60 * 1000L;
    private static final long RESEND_COOLDOWN_MILLIS = 60 * 1000L;
    private static final int MAX_VERIFY_FAIL_COUNT = 3;
    private static final SecureRandom RANDOM = new SecureRandom();

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
    public SendResult sendCode(HttpSession session, String rawEmail) {
        String email = normalizeEmail(rawEmail);
        if (email.isEmpty() || !email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            return SendResult.INVALID_EMAIL;
        }
        if (getSendCooldownRemainingSeconds(session) > 0) {
            return SendResult.COOLDOWN;
        }

        String code = String.format("%06d", RANDOM.nextInt(1_000_000));
        long expiresAt = System.currentTimeMillis() + EXPIRE_MILLIS;

        if (mockEnabled) {
            log.info("[MAIL MOCK] signup verification email={}, code={}, expiresAt={}", email, code, expiresAt);
            setPending(session, email, code, expiresAt);
            return SendResult.SUCCESS;
        }
        try {
            validateMailConfig();
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(resolveFromAddress());
            message.setTo(email);
            message.setSubject("[LinkOra] 회원가입 이메일 인증번호");
            message.setText(
                    "회원가입 이메일 인증번호는 아래 6자리입니다.\n\n"
                            + code
                            + "\n\n유효시간은 5분이며, 본 메일은 발신 전용입니다."
            );
            createSender().send(message);
            setPending(session, email, code, expiresAt);
            return SendResult.SUCCESS;
        } catch (IllegalStateException e) {
            if ("mailConfig".equals(e.getMessage())) {
                return SendResult.MAIL_CONFIG_ERROR;
            }
            if ("mailProvider".equals(e.getMessage())) {
                return SendResult.MAIL_PROVIDER_ERROR;
            }
            return SendResult.FAILED;
        } catch (Exception e) {
            log.warn("회원가입 이메일 인증번호 발송 실패: {}", e.toString());
            return SendResult.FAILED;
        }
    }

    @Override
    public VerifyResult verifyCode(HttpSession session, String rawEmail, String rawCode) {
        String email = normalizeEmail(rawEmail);
        String code = rawCode == null ? "" : rawCode.trim();
        if (email.isEmpty() || code.isEmpty()) {
            return VerifyResult.INVALID_REQUEST;
        }

        String pendingEmail = (String) session.getAttribute(ATTR_EMAIL);
        String pendingCode = (String) session.getAttribute(ATTR_CODE);
        Long expiresAt = (Long) session.getAttribute(ATTR_EXPIRES_AT);
        if (pendingEmail == null || pendingCode == null || expiresAt == null) {
            return VerifyResult.INVALID_REQUEST;
        }
        if (System.currentTimeMillis() > expiresAt) {
            clearPending(session);
            return VerifyResult.EXPIRED;
        }
        if (Boolean.TRUE.equals(session.getAttribute(ATTR_LOCKED))) {
            return VerifyResult.LOCKED;
        }
        if (!pendingEmail.equals(email) || !pendingCode.equals(code)) {
            int failCount = 0;
            Object failObj = session.getAttribute(ATTR_FAIL_COUNT);
            if (failObj instanceof Integer n) {
                failCount = n;
            }
            failCount++;
            session.setAttribute(ATTR_FAIL_COUNT, failCount);
            if (failCount >= MAX_VERIFY_FAIL_COUNT) {
                session.setAttribute(ATTR_LOCKED, true);
                return VerifyResult.LOCKED;
            }
            return VerifyResult.NOT_MATCHED;
        }
        clearPending(session);
        session.setAttribute(ATTR_VERIFIED_EMAIL, email);
        return VerifyResult.SUCCESS;
    }

    @Override
    public boolean isVerified(HttpSession session, String rawEmail) {
        String email = normalizeEmail(rawEmail);
        if (email.isEmpty()) {
            return false;
        }
        Object v = session.getAttribute(ATTR_VERIFIED_EMAIL);
        return v instanceof String s && email.equals(s);
    }

    @Override
    public long getSendCooldownRemainingSeconds(HttpSession session) {
        Object sent = session.getAttribute(ATTR_LAST_SENT_AT);
        if (!(sent instanceof Long sentAt)) {
            return 0L;
        }
        long remain = RESEND_COOLDOWN_MILLIS - (System.currentTimeMillis() - sentAt);
        if (remain <= 0) {
            return 0L;
        }
        return (remain + 999L) / 1000L;
    }

    private void setPending(HttpSession session, String email, String code, long expiresAt) {
        session.setAttribute(ATTR_EMAIL, email);
        session.setAttribute(ATTR_CODE, code);
        session.setAttribute(ATTR_EXPIRES_AT, expiresAt);
        session.setAttribute(ATTR_LAST_SENT_AT, System.currentTimeMillis());
        session.setAttribute(ATTR_FAIL_COUNT, 0);
        session.setAttribute(ATTR_LOCKED, false);
        session.removeAttribute(ATTR_VERIFIED_EMAIL);
    }

    private void clearPending(HttpSession session) {
        session.removeAttribute(ATTR_EMAIL);
        session.removeAttribute(ATTR_CODE);
        session.removeAttribute(ATTR_EXPIRES_AT);
        session.removeAttribute(ATTR_FAIL_COUNT);
        session.removeAttribute(ATTR_LOCKED);
    }

    private static String normalizeEmail(String email) {
        if (email == null) {
            return "";
        }
        String trimmed = email.trim();
        return trimmed.isEmpty() ? "" : trimmed.toLowerCase(Locale.ROOT);
    }

    private void validateMailConfig() {
        if (mailUsername == null || mailUsername.isBlank()
                || mailPassword == null || mailPassword.isBlank()) {
            throw new IllegalStateException("mailConfig");
        }
    }

    private JavaMailSenderImpl createSender() {
        MailProviderConfig provider = resolveProvider();
        JavaMailSenderImpl sender = new JavaMailSenderImpl();
        sender.setHost(provider.host());
        sender.setPort(provider.port());
        sender.setUsername(mailUsername.trim());
        sender.setPassword(mailPassword);
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
            boolean startTls = !ssl;
            return new MailProviderConfig(mailHost.trim(), port, startTls, ssl);
        }
        String domain = extractDomain(mailUsername);
        return switch (domain) {
            case "gmail.com", "googlemail.com" -> new MailProviderConfig("smtp.gmail.com", 587, true, false);
            case "naver.com" -> new MailProviderConfig("smtp.naver.com", 587, true, false);
            case "daum.net", "hanmail.net" -> new MailProviderConfig("smtp.daum.net", 465, false, true);
            case "nate.com" -> new MailProviderConfig("smtp.nate.com", 465, false, true);
            case "outlook.com", "hotmail.com", "live.com", "office365.com" ->
                    new MailProviderConfig("smtp.office365.com", 587, true, false);
            case "icloud.com", "me.com", "mac.com" -> new MailProviderConfig("smtp.mail.me.com", 587, true, false);
            default -> throw new IllegalStateException("mailProvider");
        };
    }

    private static String extractDomain(String email) {
        if (email == null) {
            return "";
        }
        int at = email.indexOf('@');
        if (at < 0 || at + 1 >= email.length()) {
            return "";
        }
        return email.substring(at + 1).toLowerCase(Locale.ROOT).trim();
    }

    private record MailProviderConfig(String host, int port, boolean startTls, boolean ssl) {
    }
}
