package com.example.workus.user.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class MyChangePwForm { // 내 비밀번호를 변경하는 Form

    private Long no; // 사번

    @NotBlank(message= "비밀번호는 필수 입력값입니다.")
    @Size(min = 8, max = 20, message = "비밀번호는 8~20자리만 가능합니다.")
    private String password; // 비밀번호
}
