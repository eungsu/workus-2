package com.example.workus.meeting.service;

import com.example.workus.calendar.vo.Calendar;
import com.example.workus.meeting.dto.MeetingForm;
import com.example.workus.meeting.mapper.MeetingMapper;
import com.example.workus.meeting.vo.Meeting;
import com.example.workus.security.LoginUser;
import com.example.workus.common.util.DateTimeUtil;
import com.example.workus.user.mapper.UserMapper;
import com.example.workus.user.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Service
@Transactional
public class MeetingService {

    @Autowired
    private MeetingMapper meetingMapper;
    @Autowired
    private UserMapper userMapper;

    public Meeting addNewMeeting(MeetingForm form) {
        User user = userMapper.getUserByUserNo(form.getUserNo());

        Meeting meeting = new Meeting();
        meeting.setStartDate(DateTimeUtil.getLocalDateTime(form.getStartDate()));
        meeting.setEndDate(DateTimeUtil.getLocalDateTime(form.getEndDate()));
        meeting.setContent(form.getContent());
        meeting.setRoom(form.getRoom());

        meeting.setUserNo(user.getNo());

        meetingMapper.insertMeeting(meeting);
        return meeting;
    }

    public List<Meeting> getEventsByDateRange(Date start, Date end, LoginUser loginUser) {
        LocalDateTime startDateTime = DateTimeUtil.toLocalDateTime(start);
        LocalDateTime endDateTime = DateTimeUtil.toLocalDateTime(end);

        return meetingMapper.selectEventsByDateRange(startDateTime, endDateTime, loginUser);
    }

    public List<Meeting> getAllEventsByDateRange(Date start, Date end) {
        LocalDateTime startDateTime = DateTimeUtil.toLocalDateTime(start);
        LocalDateTime endDateTime = DateTimeUtil.toLocalDateTime(end);

        return meetingMapper.selectAllEventsByDateRange(startDateTime, endDateTime);
    }

    public Meeting getMeetingByNo(Long meetingNo, Long userNo) {
        return meetingMapper.selectMeetingByNo(meetingNo, userNo);
    }

    public void updateMeeting(Meeting meeting, Long userNo) {
        Meeting existingMeeting = meetingMapper.selectMeetingByNoAndUser(meeting.getNo(), userNo);
        if (existingMeeting != null) {
            meetingMapper.updateMeeting(meeting);
        } else {
            throw new RuntimeException("수정할 권한이 없습니다.");
        }
    }

    public boolean deleteMeeting(Long eventId, Long userNo) {
        Meeting meeting = meetingMapper.selectMeetingByNoAndUser(eventId, userNo);
        if (meeting != null) {
            meetingMapper.deleteMeeting(eventId);
            return true;
        } else {
            return false;
        }
    }


}
