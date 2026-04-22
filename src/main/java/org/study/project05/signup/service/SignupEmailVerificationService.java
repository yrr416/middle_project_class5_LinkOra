package org.study.project05.signup.service;

import jakarta.servlet.http.HttpSession;

public interface SignupEmailVerificationService {

    enum SendResult {
        SUCCESS,
        INVALID_EMAIL,
        DUPLICATE_EMAIL,
        COOLDOWN,
        MAIL_CONFIG_ERROR,
        MAIL_PROVIDER_ERROR,
        FAILED
    }

    enum VerifyResult {
        SUCCESS,
        INVALID_REQUEST,
        EXPIRED,
        NOT_MATCHED,
        LOCKED,
        FAILED
    }

    SendResult sendCode(HttpSession session, String rawEmail);

    VerifyResult verifyCode(HttpSession session, String rawEmail, String rawCode);

    boolean isVerified(HttpSession session, String rawEmail);

    long getSendCooldownRemainingSeconds(HttpSession session);
}
