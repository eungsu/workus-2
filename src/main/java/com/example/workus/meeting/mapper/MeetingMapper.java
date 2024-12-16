package com.example.workus.meeting.mapper;

import com.example.workus.meeting.vo.Meeting;
import com.example.workus.security.LoginUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface MeetingMapper {

    Meeting selectMeetingByNo(@Param("meetingNo") Long meetingNo, @Param("userNo") Long userNo);
    List<Meeting> selectEventsByDateRange(
            @Param("start") LocalDateTime startDateTime,
            @Param("end") LocalDateTime endDateTime,
            @Param("loginUser") LoginUser loginUser);
    List<Meeting> selectAllEventsByDateRange(
            @Param("start") LocalDateTime startDateTime,
            @Param("end") LocalDateTime endDateTime);

    void insertMeeting(@Param("meeting") Meeting meeting);
    void deleteMeeting(@Param("eventId") Long eventId);
    void updateMeeting(@Param("meeting") Meeting meeting);

    Meeting selectMeetingByNoAndUser(@Param("meetingNo") long no, @Param("userNo") Long userNo);

}
