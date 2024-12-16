package com.example.workus.attendance.vo;

import lombok.*;
import org.apache.ibatis.type.Alias;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString
@Alias("atdCategory")
public class AttendanceCategory {
    private Long no;
    private String name;
    private double count;
}
