package com.example.workus.user.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.apache.ibatis.type.Alias;

@NoArgsConstructor
@Getter
@Setter
@ToString
@Alias("ParticipantInChatroomDto")
public class ParticipantInChatroomDto {
    private Long userNo;
    private String userName;
    private String positionName;
}
