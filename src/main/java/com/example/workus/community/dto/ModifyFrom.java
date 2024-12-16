package com.example.workus.community.dto;

import com.example.workus.community.vo.HashTag;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;


@Getter
@Setter
@ToString
public class ModifyFrom {
    private long feedNo;
    private String title;
    private String content;
    private String tags;
    private MultipartFile upfile;
}
