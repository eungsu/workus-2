package com.example.workus.attendance.dto;

import lombok.*;
import org.apache.ibatis.type.Alias;

import java.math.BigDecimal;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Builder
@Alias("apvReqDto")
public class AtdApprovalRequestDto {
    private Long atdNo;
    private Long approvalNo; // 결재자 번호(로그인 사용자)
    private String status;
    private BigDecimal dayTotal;

    private BigDecimal unusedDate;
    private BigDecimal usedDate;

    private int totalDay;
}