package com.example.workus.user.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class MyChangePhoneForm { // 내 연락처를 변경하는 폼

    private Long no; // 사번

    @NotBlank(message = "연락처는 필수 입력값입니다.")
    @Pattern(regexp = "^01[0-1][0-9]{3,4}[0-9]{4}$", message = "유효한 전화번호 형식이 아닙니다.")
    private String phone; // 연락처
}
