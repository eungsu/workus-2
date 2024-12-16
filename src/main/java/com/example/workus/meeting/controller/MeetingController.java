package com.example.workus.meeting.controller;

import com.example.workus.calendar.dto.CalendarForm;
import com.example.workus.calendar.vo.Calendar;
import com.example.workus.common.util.DateTimeUtil;
import com.example.workus.meeting.dto.MeetingForm;
import com.example.workus.meeting.service.MeetingService;
import com.example.workus.meeting.vo.Meeting;
import com.example.workus.security.LoginUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/meeting")
public class MeetingController {

    @Autowired
    private MeetingService meetingService;

    @PreAuthorize("isAuthenticated()")
    @GetMapping("/list")
    public String list(){ return "meeting/list"; }

    @PostMapping("/add")
    @ResponseBody
    public Meeting add(MeetingForm form, @AuthenticationPrincipal LoginUser loginUser) {
        form.setUserNo(loginUser.getNo());

        return meetingService.addNewMeeting(form);
    }

    @PostMapping("/delete")
    public ResponseEntity<String> deleteEvent(@RequestParam("id") Long eventId, @AuthenticationPrincipal LoginUser loginUser) {
        // 이벤트 삭제 로직
        boolean success = meetingService.deleteMeeting(eventId, loginUser.getNo());
        if (success) {
            return ResponseEntity.ok("삭제 성공");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("삭제 실패");
        }
    }

    @PostMapping("/update")
    @ResponseBody
    public Meeting update(@RequestParam("id") Long eventId, MeetingForm form, @AuthenticationPrincipal LoginUser loginUser) {
        System.out.println("=++++++++++++++++++++++++++++++++++++++++" + meetingService);
        Meeting meeting = meetingService.getMeetingByNo(eventId, loginUser.getNo());
        if (meeting != null) {
            meeting.setStartDate(DateTimeUtil.getLocalDateTime(form.getStartDate()));
            meeting.setEndDate(DateTimeUtil.getLocalDateTime(form.getEndDate()));
            meeting.setRoom(form.getRoom());
            meeting.setContent(form.getContent());

            // 일정 업데이트 처리
            meetingService.updateMeeting(meeting, loginUser.getNo());
            return meeting;
        } else {
            throw new RuntimeException("일정을 찾을 수 없습니다.");
        }
    }

    @PostMapping("/detail")
    @ResponseBody
    public ResponseEntity<Meeting> getMeetingDetail(@RequestParam("id") Long meetingNo, @AuthenticationPrincipal LoginUser loginUser) {
        Meeting meeting = meetingService.getMeetingByNo(meetingNo, loginUser.getNo());

        if (meeting != null) {
            return ResponseEntity.ok(meeting);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @GetMapping("/events")
    @ResponseBody
    public List<Meeting> events(
            @RequestParam("start") @DateTimeFormat(pattern = "yyyy-MM-dd") Date start,
            @RequestParam("end") @DateTimeFormat(pattern = "yyyy-MM-dd") Date end,
            @RequestParam String filter,
            @AuthenticationPrincipal LoginUser loginUser) {

        if ("myReservation".equals(filter)) {
            return meetingService.getEventsByDateRange(start, end, loginUser); // 내 예약만
        } else {
            return meetingService.getAllEventsByDateRange(start, end); // 전체 일정
        }
    }











}
