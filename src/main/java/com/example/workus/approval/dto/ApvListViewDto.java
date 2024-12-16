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
@Builder
@Alias("apvListViewDto")
public class ApvListViewDto {
    private Long no;
    private Date createdDate;
    private String title;
    private int categoryNo;
    private String categoryName;
    private Long reqUserNo;
    private String reqUserName;
    private String reqUserDeptName;
    private String status;
}