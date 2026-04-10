/**
 * 비밀번호 정책: 길이·대소문자·숫자·특수문자 포함 여부 등 복잡도 검사.
 */
package org.study.project05.common.util;

import java.util.regex.Pattern;

public final class PasswordPolicy {

    private static final Pattern PASSWORD_UPPER = Pattern.compile("[A-Z]");
    private static final Pattern PASSWORD_LOWER = Pattern.compile("[a-z]");
    private static final Pattern PASSWORD_DIGIT = Pattern.compile("[0-9]");
    private static final Pattern PASSWORD_SPECIAL = Pattern.compile("[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?`~]");

    private PasswordPolicy() {
    }

    public static boolean meetsComplexity(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        return PASSWORD_UPPER.matcher(password).find()
                && PASSWORD_LOWER.matcher(password).find()
                && PASSWORD_DIGIT.matcher(password).find()
                && PASSWORD_SPECIAL.matcher(password).find();
    }
}
