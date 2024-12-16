package com.example.workus.chat.dto;

import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("ChatroomForm")
public class ChatroomForm {
    private String chatroomTitle;
    private List<Long> userNo; // form의 name이 userNo라서 List지만 userNo로 변수명 지었음
}
