package com.example.workus.community.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
@ToString
public class FeedForm {
    private String title;
    private String content;
    private String tags;
    private MultipartFile upfile;
}
