package com.example.workus.chat.dto;

import lombok.*;
import org.springframework.web.multipart.MultipartFile;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
public class ChatForm {
    private String content;
    private MultipartFile upfile;
    private int emojiNo;
}
