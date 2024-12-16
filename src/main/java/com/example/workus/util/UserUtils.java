package com.example.workus.util;

import com.example.workus.common.exception.WorkusException;

public class UserUtils {

    public static String getFormatPhoneNumber(String phone) {
        if (phone.length() == 10) { // 10자리 숫자면
            return phone.replaceFirst("(\\d{3})(\\d{3})(\\d{4})", "$1-$2-$3");
        } else if (phone.length() == 11) { // 11자리 숫자면
            return phone.replaceFirst("(\\d{3})(\\d{4})(\\d{4})", "$1-$2-$3");
        } else {
            throw new WorkusException("유효하지 않은 전화번호 양식입니다.");
        }
    }
}
