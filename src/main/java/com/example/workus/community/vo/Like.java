package com.example.workus.community.vo;

import com.example.workus.user.vo.User;
import lombok.*;
import org.apache.ibatis.type.Alias;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("Like")
public class Like {

    private long no;

    private Feed feed;

    private User user;

}
