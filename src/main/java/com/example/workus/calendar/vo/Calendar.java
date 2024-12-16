package com.example.workus.calendar.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.apache.ibatis.type.Alias;

import java.time.LocalDateTime;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Alias("Calendar")
public class Calendar {

    private long no;
    private String name;
    private String content;

    private LocalDateTime startDate; // 시작일시
    private LocalDateTime endDate; // 종료일시
    private String location;
    private String division;
    private long userNo;
    private long deptNo;

}
