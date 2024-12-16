package com.example.workus.chat.mapper;

import com.example.workus.chat.dto.ChatroomDto;
import com.example.workus.chat.dto.ChatroomInfoDto;
import com.example.workus.chat.vo.Chatroom;
import com.example.workus.user.dto.ParticipantInChatroomDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface ChatroomMapper {

    /**
     * 로그인한 유저no를 통해 채팅방 번호들을 불러온다.
     *
     * @param userNo 로그인 유저no
     * @return 채팅방 번호
     */
    List<Long> getChatroomNoByUserNo(@Param("userNo") Long userNo);

    /**
     * 채팅방 번호를 받아서 채팅방 list에 들어가기 위한 dto를 반환한다.
     *
     * @param chatroomNo
     * @return list에 보여줄 dto
     */
    ChatroomDto getChatRoomInMenuByChatroomNo(@Param("chatroomNo") Long chatroomNo);

    /**
     * 채팅방 번호를 받아서 채팅방 제목과 그 방에 참여중인 유저들 목록을 불러온다.
     *
     * @param chatroomNo
     * @return 채팅방 제목과 방에 참여중인 유저들
     */
    ChatroomInfoDto getChatroomInfoByChatroomNo(@Param("chatroomNo") Long chatroomNo);

    /**
     * 채팅방 번호를 받아서 최근 접속 시간을 수정한다.
     *
     * @param userNo, chatroomNo, no
     */
    void updateChatroomConTime(@Param("userNo") Long userNo, @Param("chatroomNo") Long chatroomNo, @Param("now") LocalDateTime now);

    /**
     * 채팅방 번호와 유저 번호를 받아서 읽지 않은 메시지 수를 반환한다.
     *
     * @param chatroomNo
     * @return 읽지 앟은 메시지 수
     */
    int getNotReadCount(@Param("userNo") Long userNo, @Param("chatroomNo") Long chatroomNo);

    /**
     * 부서에 해당하는 유저들을 가져온다.
     *
     * @param deptName 부서이름
     * @return 부서에 속한 유저들
     */
    List<ParticipantInChatroomDto> getAllUsersByDeptName(@Param("deptName") String deptName);

    /**
     * 채팅방을 생성한다.
     *
     * @param chatroom 채팅방 객체
     */
    void addChatroom(@Param("chatroom") Chatroom chatroom);

    /**
     * 채팅방 참여 히스토리에 저장한다.
     *
     * @param chatroomNo        채팅방 번호
     * @param participantUserNo 참여자 번호
     */
    void addChatroomHistory(@Param("chatroomNo") Long chatroomNo, @Param("participantUserNo") Long participantUserNo);

    /**
     * 채팅방 번호로 채팅방 객체를 가져온다.
     *
     * @param chatroomNo 채팅방 번호
     * @return 채팅방 객체
     */
    Chatroom getChatroomByChatroomNo(@Param("chatroomNo") Long chatroomNo);

    /**
     * 채팅방 번호를 받아서 out_time을 업데이트 한다.
     *
     * @param userNo     나갈 유저 번호
     * @param chatroomNo 채팅방 번호
     */
    void outChatroomByChatroomNo(@Param("userNo") Long userNo, @Param("chatroomNo") Long chatroomNo);
}
