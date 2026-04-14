package org.study.project05.common.util;

import jakarta.servlet.http.HttpSession;

/**
 * SessionUtil - 세션 정보를 안전하게 추출하기 위한 유틸리티
 */
public class SessionUtil {

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
}
