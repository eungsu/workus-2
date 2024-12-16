package com.example.workus.chat.dto;

import com.example.workus.user.vo.User;
import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("ChatroomDto")
public class ChatroomDto {

    private Long chatroomNo;
    private String chatroomTitle;
    private User lastChatAuthor;
    private String lastChat;
    private Date lastChatDate;
    private int notReadCount;
}
