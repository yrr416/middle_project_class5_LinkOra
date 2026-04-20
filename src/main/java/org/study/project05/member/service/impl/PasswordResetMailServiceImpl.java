/**
 * 임시 비밀번호·아이디 안내 메일을 SMTP로 발송(또는 mock 로그)하는 구현.
 */
package org.study.project05.member.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Service;
import org.study.project05.member.service.PasswordResetMailService;

import java.util.Locale;
import java.util.Properties;

@Service
public class PasswordResetMailServiceImpl implements PasswordResetMailService {

    private static final Logger log = LoggerFactory.getLogger(PasswordResetMailServiceImpl.class);

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

    public PasswordResetMailServiceImpl() {
    }

    public void sendTemporaryPassword(
            String toEmail,
            String name,
            String temporaryPassword,
            String memberUserIdsCsv,
            String partnerLoginIdsCsv
    ) {
        if (mockEnabled) {
            log.info("[MAIL MOCK] temporary password email={}, name={}, temporaryPassword={}, memberIds={}, partnerIds={}",
                    toEmail, name, temporaryPassword, memberUserIdsCsv, partnerLoginIdsCsv);
            return;
        }
        validateMailConfig();
        String displayName = (name == null || name.isBlank()) ? "회원" : name.trim();

        StringBuilder loginBlock = new StringBuilder();
        if (memberUserIdsCsv != null && !memberUserIdsCsv.isBlank()) {
            loginBlock.append("일반 회원 로그인 아이디: ").append(memberUserIdsCsv).append('\n');
        }
        if (partnerLoginIdsCsv != null && !partnerLoginIdsCsv.isBlank()) {
            loginBlock.append("사업자 회원 로그인 아이디: ").append(partnerLoginIdsCsv).append('\n');
        }
        if (loginBlock.length() == 0) {
            loginBlock.append("로그인 화면의 \"아이디\"에는 가입 시 사용한 아이디를 입력해주세요.\n");
        }
        loginBlock.append('\n');

        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(resolveFromAddress());
        message.setTo(toEmail);
        message.setSubject("[LinkOra] 임시 비밀번호 안내");
        message.setText(
                displayName + "님,\n\n"
                        + "요청하신 임시 비밀번호를 발급해드렸습니다.\n\n"
                        + loginBlock
                        + "임시 비밀번호: " + temporaryPassword + "\n\n"
                        + "로그인 시 위 아이디와 임시 비밀번호를 함께 사용해주세요. (이메일 주소는 아이디로 사용할 수 없습니다.)\n"
                        + "로그인 후 마이페이지에서 비밀번호를 반드시 변경해주세요.\n"
                        + "본 메일은 발신 전용입니다."
        );
        createSender().send(message);
    }

    public void sendUserId(String toEmail, String name, String userId) {
        if (mockEnabled) {
            log.info("[MAIL MOCK] user id email={}, name={}, userId={}", toEmail, name, userId);
            return;
        }
        validateMailConfig();
        String displayName = (name == null || name.isBlank()) ? "회원" : name.trim();

        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(resolveFromAddress());
        message.setTo(toEmail);
        message.setSubject("[LinkOra] 아이디 찾기 안내");
        message.setText(
                displayName + "님,\n\n"
                        + "요청하신 아이디를 안내해드립니다.\n"
                        + "아이디: " + userId + "\n\n"
                        + "본 메일은 발신 전용입니다."
        );
        createSender().send(message);
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
