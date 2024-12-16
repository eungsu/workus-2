package com.example.workus.community.vo;

import com.example.workus.user.vo.User;
import lombok.*;
import org.apache.ibatis.type.Alias;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("Reply")
public class Reply {
    private long no;
    private String content;
    private Date createdDate;

    private Feed feed;

    private User user;

}
