/**
 * 한국 휴대전화 번호를 {@code xxx-xxxx-xxxx} 형태로 정규화하는 유틸리티.
 */
package org.study.project05.common.util;

public final class PhoneNumberUtil {

    private PhoneNumberUtil() {
    }

    public static String normalizeKoreanMobile(String raw) {
        if (raw == null || raw.isBlank()) {
            return "";
        }
        String s = raw.trim().replaceAll("\\s+", "");
        if (s.startsWith("+82")) {
            s = "0" + s.substring(3).replaceAll("[^0-9]", "");
        } else {
            s = s.replaceAll("[^0-9]", "");
        }
        if (s.length() == 11 && s.startsWith("010")) {
            return s.substring(0, 3) + "-" + s.substring(3, 7) + "-" + s.substring(7);
        }
        if (s.length() == 10 && s.startsWith("02")) {
            return s.substring(0, 2) + "-" + s.substring(2, 6) + "-" + s.substring(6);
        }
        return raw.trim();
    }
}
