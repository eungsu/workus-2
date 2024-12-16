package com.example.workus.calendar.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CalendarForm {
     private String name;
     private String location;
     private String startDate;
     private String endDate;
     private String division;
     private String content;

     private Long userNo;
     private Long deptNo;
}
