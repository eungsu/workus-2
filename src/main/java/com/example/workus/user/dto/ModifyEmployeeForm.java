package com.example.workus.user.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import java.sql.Date;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class ModifyEmployeeForm {
    
    private String name; // 이름
    private String email; // 이메일
    private String phone; // 연락처
    private String address; // 주소
    private Date birthDate; // 생년월일
    private Date hireDate; // 입사일
    private Date quitDate; // 퇴사일
    private Date leaveDate; // 휴직일
    private Long deptNo; // 부서 번호
    private Long positionNo; // 직책 번호
    private int roleNo; // 역할 번호
    private double unusedAnnualLeave; // 연차 개수
    private MultipartFile image; // 이미지 파일
}
