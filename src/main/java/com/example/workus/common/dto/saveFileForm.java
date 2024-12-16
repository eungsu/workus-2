package com.example.workus.common.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@NoArgsConstructor
@Getter
@Setter
public class saveFileForm {
    private String title;
    private String description;
    private MultipartFile saveFile;
}
