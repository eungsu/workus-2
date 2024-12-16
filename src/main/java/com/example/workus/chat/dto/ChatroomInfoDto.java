package com.example.workus.chat.dto;

import com.example.workus.user.vo.User;
import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("ChatroomInfoDto")
public class ChatroomInfoDto {
    private String chatroomTitle;
    private List<User> users;
}
