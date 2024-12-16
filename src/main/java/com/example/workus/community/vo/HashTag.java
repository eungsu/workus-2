package com.example.workus.community.vo;

import lombok.*;
import org.apache.ibatis.type.Alias;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Alias("HashTag")
public class HashTag {
    private Long no;
    private String name;

    private Feed feed;
}
