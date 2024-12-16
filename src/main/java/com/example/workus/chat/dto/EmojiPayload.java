package com.example.workus.chat.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class EmojiPayload implements Payload {
    private int emojiNo;
    private String fileSrc;
}
