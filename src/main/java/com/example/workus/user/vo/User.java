package com.example.workus.user.vo;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@ToString
@Alias("User")
public class User {
    private Long no;
    private String id;
    private String name;
    @JsonIgnore
    private String password;
    private String email;
    private String address;
    private Date birthday;
    private Date hireDate;
    private Date quitDate;
    private Date leaveDate; // 휴직일
    private String status;
    private String profileSrc;
    private String pr;
    private String phone;
    private double unusedAnnualLeave;
    private long positionNo;
    private String positionName;
    private Long deptNo;
    private String deptName;
    private int roleNo;
    private String roleName;
}
