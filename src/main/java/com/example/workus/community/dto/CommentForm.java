package com.example.workus.community.dto;

import com.example.workus.user.vo.User;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CommentForm {
    private String comment;
    private Long feedNo;
}
