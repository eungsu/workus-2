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
@Alias("AddUserInChatroomForm")
public class AddNewUserInChatroomForm {
    private Long chatroomNo;
    private List<User> users;
}
