package com.example.workus.attendance.dto;

import lombok.*;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Builder
@Alias("apvForm")
public class AtdApprovalForm {
    private Long no;
    private String reason;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date fromDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date toDate;
    private Date createdDate;
    private Long categoryNo;
    private Long userNo;
    private String time;
    private String apv;
    private String ref;
    private int totalDay;
}
