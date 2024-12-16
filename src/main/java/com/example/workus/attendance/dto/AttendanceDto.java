package com.example.workus.attendance.dto;

import lombok.*;

import java.math.BigDecimal;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Builder
public class AttendanceDto {
    private Long no;
    private int roleNo;
    private BigDecimal unusedAnnualLeave;
    private BigDecimal annualLeaveCount;
}
