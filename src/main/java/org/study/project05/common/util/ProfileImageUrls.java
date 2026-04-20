package org.study.project05.common.util;

import jakarta.servlet.http.HttpServletRequest;

/**
 * DB에 저장된 프로필 경로를 요청 기준 표시 URL로 변환한다.
 */
public final class ProfileImageUrls {

    private ProfileImageUrls() {
    }

    public static String forRequest(HttpServletRequest request, String storedPath) {
        if (storedPath == null || storedPath.isBlank()) {
            return null;
        }
        String trimmed = storedPath.trim();
        if (trimmed.startsWith("/uploads/profiles/")) {
            trimmed = "/static/upload/profiles/" + trimmed.substring("/uploads/profiles/".length());
        }
        if (trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
            return trimmed;
        }
        String contextPath = request != null && request.getContextPath() != null
                ? request.getContextPath()
                : "";
        if (trimmed.startsWith("/")) {
            return contextPath + trimmed;
        }
        return contextPath + "/" + trimmed;
    }
}
