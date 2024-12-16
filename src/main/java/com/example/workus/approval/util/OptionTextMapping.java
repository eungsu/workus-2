package com.example.workus.approval.util;

import java.util.HashMap;
import java.util.Map;

public class OptionTextMapping {
    private static final Map<Integer, Map<String, String>> optionTextMap = new HashMap<>();

    static {
        // 카테고리 100
        Map<String, String> options100 = new HashMap<>();
        options100.put("agent", "업무대행자");
        options100.put("handover", "인수인계 상황");
        optionTextMap.put(100, options100);

        // 카테고리 200
        Map<String, String> options200 = new HashMap<>();
        options200.put("diseaseName", "병명");
        options200.put("agent", "업무대행자");
        options200.put("handover", "인수인계 상황");
        optionTextMap.put(200, options200);

        // 카테고리 400
        Map<String, String> options400 = new HashMap<>();
        options400.put("work", "예정 작업 내용");
        optionTextMap.put(400, options400);

        // 카테고리 500
        Map<String, String> options500 = new HashMap<>();
        options500.put("curriculum", "교육과정명");
        options500.put("location", "교육기관");
        options500.put("accompany", "동행자");
        options500.put("content", "교육내용");
        optionTextMap.put(500, options500);

        // 카테고리 600
        Map<String, String> options600 = new HashMap<>();
        options600.put("location", "외근 지역");
        options600.put("accompany", "외근 동행자");
        options600.put("work", "주요 업무");
        options600.put("transport", "이동 방안");
        options600.put("ready", "준비사항");
        optionTextMap.put(600, options600);

        // 카테고리 700
        Map<String, String> options700 = new HashMap<>();
        options700.put("location", "방문처");
        options700.put("time", "방문 시간");
        optionTextMap.put(700, options700);
    }

    public static Map<String, String> getOptionsByCategory(int categoryNo) {
        return optionTextMap.getOrDefault(categoryNo, new HashMap<>()); // 기본값은 빈 맵
    }
}
