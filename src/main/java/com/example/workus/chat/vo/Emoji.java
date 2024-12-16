package com.example.workus.chat.vo;

import lombok.*;
import org.apache.ibatis.type.Alias;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("Emoji")
public class Emoji {
    private int no;
    private String fileSrc;
    private String previewFileSrc;
}
