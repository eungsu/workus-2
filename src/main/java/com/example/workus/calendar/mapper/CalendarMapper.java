package com.example.workus.calendar.mapper;

import com.example.workus.calendar.vo.Calendar;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface CalendarMapper {

    Calendar selectCalendarByNoAndUser(@Param("calendarNo") Long calendarNo, @Param("userNo") Long userNo);
    Calendar selectCalendarByNo(@Param("calendarNo") Long calendarNo);

    List<Calendar> selectTeamAndPersonalEvents(
            @Param("userNo") long userNo,
            @Param("deptNo") long deptNo,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            @Param("division") List<Integer> division
    );

    void insertCalendar(@Param("calendar") Calendar calendar);
    void deleteCalendar(@Param("eventId") Long eventId);
    void updateCalendar(@Param("calendar") Calendar calendar);

    List<Calendar> selectPersonalEvents(
            @Param("userNo") Long userNo,
            @Param("startDateTime") LocalDateTime startDateTime,
            @Param("endDateTime") LocalDateTime endDateTime,
            @Param("division") List<Integer> division
    );
    List<Calendar> selectTeamEvents(
            @Param("deptNo") Long deptNo,
            @Param("startDateTime") LocalDateTime startDateTime,
            @Param("endDateTime") LocalDateTime endDateTime,
            @Param("division") List<Integer> division
    );

    List<Calendar> selectMyCalendarEvents(
            @Param("userNo") Long userNo,
            @Param("start") LocalDateTime startDateTime,
            @Param("end") LocalDateTime endDateTime,
            @Param("division") List<Integer> division
    );
}
