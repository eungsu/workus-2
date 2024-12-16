package com.example.workus.calendar.controller;

import com.example.workus.calendar.dto.CalendarForm;
import com.example.workus.calendar.service.CalendarService;
import com.example.workus.calendar.vo.Calendar;
import com.example.workus.security.LoginUser;
import com.example.workus.common.util.DateTimeUtil;
import com.example.workus.user.mapper.UserMapper;
import com.example.workus.user.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/calendar")
public class CalendarController {

    @Autowired
    private CalendarService calendarService;
    @Autowired
    private UserMapper userMapper;

    // 일정 목록 화면
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/list")
    public String list() {
        return "calendar/list";
    }

    // 일정 추가
    @PostMapping("/add")
    @ResponseBody
    public Calendar add(CalendarForm form, @AuthenticationPrincipal LoginUser loginUser) {
        form.setUserNo(loginUser.getNo()); // 로그인 사용자 정보 설정

        // 새 일정 추가
        return calendarService.addNewCalendar(form);
    }

    // 일정 삭제
    @PostMapping("/delete")
    public ResponseEntity<String> deleteEvent(@RequestParam("id") Long eventId, @AuthenticationPrincipal LoginUser loginUser) {
        boolean success = calendarService.deleteCalendar(eventId, loginUser.getNo()); // 로그인 사용자의 일정만 삭제
        if (success) {
            return ResponseEntity.ok("삭제 성공");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("삭제 실패");
        }
    }

    // 일정 수정
    @PostMapping("/update")
    @ResponseBody
    public Calendar update(@RequestParam("id") Long eventId, CalendarForm form, @AuthenticationPrincipal LoginUser loginUser) {
        // 수정할 일정을 가져와서 폼 데이터로 업데이트
        Calendar calendar = calendarService.getCalendarByNo(eventId, loginUser.getNo());
        if (calendar != null) {
            calendar.setName(form.getName());
            calendar.setLocation(form.getLocation());
            calendar.setStartDate(DateTimeUtil.getLocalDateTime(form.getStartDate()));
            calendar.setEndDate(DateTimeUtil.getLocalDateTime(form.getEndDate()));
            calendar.setDivision(form.getDivision());
            calendar.setContent(form.getContent());

            // 일정 업데이트 처리
            calendarService.updateCalendar(calendar, loginUser.getNo());
            return calendar;
        } else {
            throw new RuntimeException("일정을 찾을 수 없습니다.");
        }
    }

    // 일정 상세 조회
    @PostMapping("/detail")
    @ResponseBody
    public ResponseEntity<Calendar> getCalendarDetail(@RequestParam("id") Long calendarNo) {
        Calendar calendar = calendarService.getCalendarByNo(calendarNo);
        if (calendar != null) {
            return ResponseEntity.ok(calendar);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @GetMapping("/events")
    @ResponseBody
    public List<Calendar> events(
            @RequestParam("start") @DateTimeFormat(pattern = "yyyy-MM-dd") Date start,
            @RequestParam("end") @DateTimeFormat(pattern = "yyyy-MM-dd") Date end,
            @RequestParam String filter,
            @RequestParam List<Integer> division,
            @AuthenticationPrincipal LoginUser loginUser) {

        // 로그인 사용자 정보 조회
        User user = userMapper.getUserByUserNo(loginUser.getNo());

        switch (filter) {
            case "division1":
                return calendarService.getEventsByDateRange(start, end, user.getNo(), null, division); // 개인 일정
            case "division0":
                return calendarService.getEventsByDateRange(start, end, null, user.getDeptNo(), division); // 팀 일정
            case "divisionAll":
                return calendarService.getAllEventsByDateRange(start, end, user.getNo(), user.getDeptNo(), division); // 개인 + 팀 일정`
            case "myCalendar":
                return calendarService.getMyCalendarEvents(start, end, user.getNo(), division); // 내 일정 목록
            default:
                return calendarService.getAllEventsByDateRange(start, end, user.getNo(), user.getDeptNo(), division); // 기본 개인 + 팀 일정
        }
    }
}
