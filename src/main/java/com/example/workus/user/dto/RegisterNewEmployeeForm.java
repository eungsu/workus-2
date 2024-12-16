package com.example.workus.user.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import java.sql.Date;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class RegisterNewEmployeeForm { // 신규 직원을 등록하는 입력폼
    
    private Long no; // 사번
    private String name; // 이름
    private Date birthDate; // 생년월일
    private Date hireDate; // 입사일
    private Long deptNo; // 부서 번호
    private Long positionNo; // 직책 번호
    private int roleNo; // 역할 번호
    private double unusedAnnualLeave; // 미사용 연차 개수
    private MultipartFile image; // 이미지 파일
    
}
