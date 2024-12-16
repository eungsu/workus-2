package com.example.workus.approval.dto;


import lombok.*;
import org.apache.ibatis.type.Alias;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Builder
public class ApvApprovalForm {
    private Long no;
    private Long userNo;
    private int categoryNo;
    private String title;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date fromDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date toDate;
    private String commonText;
    private String reason;

    private Map<String, String> optionTexts = new HashMap<>(); // option text DTO 조합
}
