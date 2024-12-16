package com.example.workus.meeting.vo;

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
@Alias("Meeting")
public class Meeting {

    private long no;
    private LocalDateTime startDate; // 시작일시
    private LocalDateTime endDate; // 종료일시
    private String room;
    private String content;

    private long userNo;
}
