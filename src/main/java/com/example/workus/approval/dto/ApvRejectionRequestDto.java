package com.example.workus.approval.dto;

import lombok.*;
import org.apache.ibatis.type.Alias;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Builder
@Alias("rejectionReqDto")
public class ApvRejectionRequestDto {
    private Long no;
    private String status;
    private Long reqUserNo;
    private String reason;
}
