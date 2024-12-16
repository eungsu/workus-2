package com.example.workus.user.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class MyModifyForm { // 자기 자신의 정보를 수정하는 클래스

    private Long no; // 사번
    private String pr; // 자기소개
    private String address; // 주소
    private MultipartFile image; // 이미지 파일
}
