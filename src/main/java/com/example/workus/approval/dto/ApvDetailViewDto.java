package com.example.workus.approval.dto;

import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.Date;
import java.util.List;
import java.util.Map;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("apvDetailViewDto")
public class ApvDetailViewDto extends ApvListViewDto{
    private Date fromDate;
    private Date toDate;
    private String commonText;
    private String commonTextTitle;
    private String reason;
    private String reasonTitle;
    private Long apvUserNo;
    private String apvUserName;
    private String apvUserPositionName;
    private String rejectionReason;
    private List<Map<String, String>> optionTexts;
}
