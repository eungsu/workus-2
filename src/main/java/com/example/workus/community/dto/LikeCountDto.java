package com.example.workus.community.dto;

import com.example.workus.community.vo.Like;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
public class LikeCountDto {
    private String userName;
    private int likeCount;
}
