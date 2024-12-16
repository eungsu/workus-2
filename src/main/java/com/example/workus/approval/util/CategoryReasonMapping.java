package com.example.workus.approval.util;

import java.util.HashMap;
import java.util.Map;

public class CategoryReasonMapping {

    private static final Map<Integer, String> reasonMap = new HashMap<>();

    static {
        reasonMap.put(100, "휴직 사유");
        reasonMap.put(200, "휴직 사유");
        reasonMap.put(300, "복직 사유");
        reasonMap.put(500, "참석목적");
        reasonMap.put(600, "외근 목적");
        reasonMap.put(700, "방문 동기");
    }

    public static String getReasonByCategory(int categoryNo) {
        return reasonMap.getOrDefault(categoryNo, "기타 사유"); // 기본값 설정
    }
}
