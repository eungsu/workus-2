package com.example.workus.chat.vo;

import com.example.workus.user.vo.User;
import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("ChatroomHistory")
public class ChatroomHistroy {
    private Long no;
    private Date enterTime;
    private Date outTime;
    private Date conTime;
    private User user;
    private Chatroom chatroom;
}
