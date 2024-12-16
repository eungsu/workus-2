package com.example.workus.attendance.dto;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Builder
public class AtdApprovalUserDto {
    private Long no;
    private String status;
    private int sequence;
    private Long userNo;
    private Long formNo;
}
