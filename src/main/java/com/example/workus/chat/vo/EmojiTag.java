package com.example.workus.chat.vo;

import lombok.*;
import org.apache.ibatis.type.Alias;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("EmojiTag")
public class EmojiTag {
    private int no;
    private String name;
    private Emoji emoji;
}
