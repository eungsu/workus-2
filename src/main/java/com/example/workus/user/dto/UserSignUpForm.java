package com.example.workus.user.dto;

import jakarta.validation.constraints.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class UserSignUpForm {

    @Positive(message = "사번은 필수 입력값입니다.")
    private Long no;

    @NotBlank(message = "ID는 필수 입력값입니다.")
    private String id;

    @NotBlank(message= "비밀번호는 필수 입력값입니다.")
    @Size(min = 8, max = 20, message = "비밀번호는 8~20자리만 가능합니다.")
    private String password;

    @NotBlank(message = "비밀번호 확인은 필수 입력값입니다.")
    @Size(min = 8, max = 20, message= "비밀번호는 8~20자리만 가능합니다.")
    private String passwordConfirm;

    @NotBlank(message = "연락처는 필수 입력값입니다.")
    @Pattern(regexp = "^01[0-1][0-9]{3,4}[0-9]{4}$", message = "유효한 전화번호 형식이 아닙니다.")
    private String phone;

    @NotBlank(message = "주소는 필수 입력값입니다.")
    private String address;

    @NotBlank(message = "상세주소는 필수 입력값입니다.")
    private String detailAddress;
}
