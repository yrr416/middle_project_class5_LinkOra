package org.study.project05.common.util;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * brnHours 자유 텍스트에서 오늘 영업 시작/종료 시간을 파싱하는 유틸리티
 *
 * 지원 형식:
 *   "연중무휴 24시간"
 *   "평일 09:00~20:00 (주말 휴무)"
 *   "평일 07:00~22:00"
 *   "수 09:00~18:00"
 *   "월,화,수,목,금,토,일 09:00~18:00"
 *   "09:00 ~ 22:00"
 */
public class BizHoursUtil {

    private static final Pattern TIME_PATTERN =
            Pattern.compile("(\\d{2}):(\\d{2})\\s*~\\s*(\\d{2}):(\\d{2})");

    /** DayOfWeek → 한글 단일 요일 문자 */
    private static final Map<DayOfWeek, String> DAY_CHAR = Map.of(
            DayOfWeek.MONDAY,    "월",
            DayOfWeek.TUESDAY,   "화",
            DayOfWeek.WEDNESDAY, "수",
            DayOfWeek.THURSDAY,  "목",
            DayOfWeek.FRIDAY,    "금",
            DayOfWeek.SATURDAY,  "토",
            DayOfWeek.SUNDAY,    "일"
    );

    /**
     * brnHours에서 오늘 영업 시작/종료 시(hour) 파싱
     *
     * @return int[2] { openHour, closeHour }
     *   - 명시적 24시간: { 0, 24 }
     *   - 휴무:          { 0,  0 }
     *   - 매칭 실패:     { -1, -1 }  ← 정보 부족 (열려있는지 알 수 없음)
     */
    public static int[] parseBizHours(String brnHours) {
        if (brnHours == null || brnHours.isBlank()) return new int[]{-1, -1};
        if (brnHours.contains("24시간"))             return new int[]{0, 24};

        DayOfWeek dow     = LocalDate.now().getDayOfWeek();
        String todayChar  = DAY_CHAR.get(dow); // "월","화",...

        // 우선순위 키워드: 긴 키워드(평일/토요일 등) → 단일 요일명
        String[] keywords;
        if (dow == DayOfWeek.SUNDAY)        keywords = new String[]{"일요일", "주말", todayChar};
        else if (dow == DayOfWeek.SATURDAY) keywords = new String[]{"토요일", "주말", todayChar};
        else                                keywords = new String[]{"평일", todayChar};

        String[] lines = brnHours.split("\n");
        String matched        = null;
        String matchedKeyword = null;

        outer:
        for (String kw : keywords) {
            for (String line : lines) {
                boolean hit = (kw.length() == 1)
                        ? dayPartContains(line, kw)  // 단일 요일명: 콤마 구분 파트에서 검사
                        : line.contains(kw);         // 평일/주말 등: 단순 포함 검사
                if (hit) { matched = line; matchedKeyword = kw; break outer; }
            }
        }

        // 키워드 없이 시간만 있는 줄 (예: "09:00 ~ 22:00") → 전체 요일 적용
        if (matched == null) {
            for (String line : lines) {
                if (line.trim().matches("\\d{2}:\\d{2}\\s*~\\s*\\d{2}:\\d{2}")) {
                    matched = line; break;
                }
            }
        }

        if (matched == null) return new int[]{-1, -1}; // 매칭 실패 → 정보 없음

        // 키워드 이후 텍스트만 추출
        String relevant = (matchedKeyword != null)
                ? matched.substring(matched.indexOf(matchedKeyword) + matchedKeyword.length())
                : matched;

        // 시간 패턴 우선 파싱
        Matcher m = TIME_PATTERN.matcher(relevant);
        if (m.find()) return new int[]{Integer.parseInt(m.group(1)), Integer.parseInt(m.group(3))};

        // 시간 없고 휴무
        if (relevant.contains("휴무")) return new int[]{0, 0};

        return new int[]{-1, -1};
    }

    /**
     * 현재 시각 기준 영업 상태 문자열 반환
     * @return "영업중" | "영업종료" | "오늘 휴무" | "" (정보 부족)
     */
    public static String getBizStatus(String brnHours) {
        if (brnHours == null || brnHours.isBlank()) return "";

        int[] biz = parseBizHours(brnHours);
        int open  = biz[0];
        int close = biz[1];

        if (open == -1)           return "";          // 오늘 정보 없음 → 배지 표시 안 함
        if (open == 0 && close == 0)  return "오늘 휴무";
        if (open == 0 && close == 24) return "영업중"; // 명시적 24시간

        int nowHour = LocalTime.now().getHour();
        return (nowHour >= open && nowHour < close) ? "영업중" : "영업종료";
    }

    /**
     * 줄에서 시간 패턴 이전의 '요일 선언' 파트에 dayChar(한글 단일 문자)가 포함되는지 확인
     * e.g. "월,화,수,목,금 09:00~18:00" + "수" → dayPart="월,화,수,목,금" → true
     * e.g. "수 09:00~18:00"             + "수" → dayPart="수"            → true
     */
    private static boolean dayPartContains(String line, String dayChar) {
        String dayPart = TIME_PATTERN.split(line, 2)[0]; // 시간 패턴 앞부분만
        for (String token : dayPart.split("[,\\s]+")) {
            if (token.trim().equals(dayChar)) return true;
        }
        return false;
    }
}
