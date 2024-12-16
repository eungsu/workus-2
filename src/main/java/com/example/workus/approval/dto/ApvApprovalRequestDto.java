package com.example.workus.approval.dto;

import lombok.*;
import org.apache.ibatis.type.Alias;

import java.math.BigDecimal;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Builder
@Alias("approvalReqDto")
public class ApvApprovalRequestDto {
    private Long no;
    private String status;
    private Long reqUserNo;
}
