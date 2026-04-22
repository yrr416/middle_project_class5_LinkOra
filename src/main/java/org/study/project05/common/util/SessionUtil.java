package org.study.project05.common.util;

import jakarta.servlet.http.HttpSession;

import java.util.Set;

/**
 * SessionUtil - 세션 정보를 안전하게 추출하기 위한 유틸리티
 */
public class SessionUtil {

    /** 로그인 성공 후 이동할 내부 경로(비밀번호 찾기 메일 등에서 설정). */
    public static final String POST_LOGIN_REDIRECT_ATTR = "postLoginRedirect";

    private static final Set<String> ALLOWED_POST_LOGIN_PATHS = Set.of("/mypage", "/partner/mypage");

    /**
     * 세션에서 로그인한 사용자의 고유 번호(userIdx)를 추출합니다.
     * @param session HttpSession
     * @return userIdx (로그인 안된 경우 null)
     */
    public static Integer getUserIdx(HttpSession session) {
        Object uIdxObj = session.getAttribute("userIdx");
        if (uIdxObj == null) return null;
        
        try {
            if (uIdxObj instanceof Integer) return (Integer) uIdxObj;
            if (uIdxObj instanceof Long) return ((Long) uIdxObj).intValue();
            return Integer.parseInt(String.valueOf(uIdxObj));
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 세션에서 로그인한 사용자의 이름(userName)을 추출합니다.
     * @param session HttpSession
     * @return userName
     */
    public static String getUserName(HttpSession session) {
        Object name = session.getAttribute("userName");
        return name != null ? String.valueOf(name) : "Guest";
    }

    /**
     * 로그인 페이지의 {@code next} 쿼리가 허용된 내부 경로일 때만 세션에 저장한다.
     */
    public static void storePostLoginRedirectIfValid(HttpSession session, String rawNext) {
        String sanitized = sanitizePostLoginRedirect(rawNext);
        if (sanitized != null) {
            session.setAttribute(POST_LOGIN_REDIRECT_ATTR, sanitized);
        }
    }

    public static String peekPostLoginRedirect(HttpSession session) {
        Object v = session.getAttribute(POST_LOGIN_REDIRECT_ATTR);
        return v instanceof String s ? s : null;
    }

    public static void clearPostLoginRedirect(HttpSession session) {
        session.removeAttribute(POST_LOGIN_REDIRECT_ATTR);
    }

    /**
     * 오픈 리다이렉트 방지: 마이페이지(일반·사업자)만 허용한다.
     */
    public static String sanitizePostLoginRedirect(String raw) {
        if (raw == null) {
            return null;
        }
        String t = raw.strip();
        if (t.isEmpty() || !t.startsWith("/") || t.startsWith("//") || t.contains("..")) {
            return null;
        }
        return ALLOWED_POST_LOGIN_PATHS.contains(t) ? t : null;
    }
}
