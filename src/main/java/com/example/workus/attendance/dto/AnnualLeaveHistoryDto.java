package com.example.workus.attendance.dto;

import com.example.workus.user.dto.DeptDto;
import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.Date;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Builder
@Alias("CalDto")
public class AnnualLeaveHistoryDto {
    private Long userNo;
    private String userName;
    private Date fromDate;
    private Date toDate;
    private String time;
    private Long deptNo;
    private String deptName;
    private String categoryName;
    //    private List<DeptDto> departments; // 부서 정보를 담을 리스트
    private int totalDay;
}
