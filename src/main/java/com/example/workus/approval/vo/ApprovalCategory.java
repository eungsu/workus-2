package com.example.workus.approval.vo;

import lombok.*;
import org.apache.ibatis.type.Alias;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
@ToString
@Alias("apvCategory")
public class ApprovalCategory {
    private int no;
    private String name;
}
