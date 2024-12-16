package com.example.workus.meeting.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MeetingForm {

    private String startDate;
    private String endDate;
    private String room;
    private String content;

    private Long userNo;
}
