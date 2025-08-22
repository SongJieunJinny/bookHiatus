package com.bookGap.util;

public class StringUtils {

	// 유틸 클래스이므로 인스턴스화 방지
    private StringUtils() {}

    /**
     * 문자열이 null, ""(빈 문자열), 공백만 있는 경우 true 반환
     *
     * @param s 검사할 문자열
     * @return 문자열이 비어있거나(null, "" or 공백만 존재) true, 아니면 false
     */
    public static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    /**
     * 문자열이 null, ""(빈 문자열), 공백만 있는 경우 null 반환
     * 그렇지 않으면 trim()된 문자열 반환
     *
     * @param s 검사할 문자열
     * @return null 또는 trim() 결과
     */
    public static String emptyToNull(String s) {
        return isBlank(s) ? null : s.trim();
    }

    /**
     * 문자열이 null, ""(빈 문자열), 공백만 있는 경우 기본값(defaultValue) 반환
     * 그렇지 않으면 trim()된 문자열 반환
     *
     * @param s 검사할 문자열
     * @param defaultValue 기본으로 대체할 값
     * @return defaultValue 또는 trim() 결과
     */
    public static String defaultIfBlank(String s, String defaultValue) {
        return isBlank(s) ? defaultValue : s.trim();
    }
}
