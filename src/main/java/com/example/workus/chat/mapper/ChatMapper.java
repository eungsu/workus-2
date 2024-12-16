package com.example.workus.chat.mapper;

import com.example.workus.chat.vo.Chat;
import com.example.workus.chat.vo.Emoji;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

@Mapper
public interface ChatMapper {

    /**
     * chat 객체를 받아서 그 날 첫 번째 채팅인지 확인한다.
     * @param chat 객체
     * @return 'Y' 혹은 'N'
     */
    Character checkDailyFirstChat(@Param("chat") Chat chat);

    /**
     * 채팅방 번호를 받아서 방번호에 해당하는 채팅들을 페이지에 맞게 출력한다.
     * @param userNo 로그인한 유저 번호
     * @param chatroomNo 채팅방 번호
     * @param begin 시작
     * @return 해당하는 채팅들
     */
    List<Chat> getAllChatsByChatroomNo(@Param("userNo") Long userNo,
                                       @Param("chatroomNo") Long chatroomNo,
                                       @Param("begin") int begin);

    /**
     * 채팅 객체를 받아서 insert한다.
     * @param chat 객체
     */
    void insertChat(@Param("chat") Chat chat);

    /**
     * 채팅 총 갯수를 가져온다.
     * @param userNo 로그인한 유저 번호
     * @param chatroomNo 채팅 방 번호
     * @return 채팅 총 갯수
     */
    int getTotalRows(@Param("userNo") Long userNo, @Param("chatroomNo") Long chatroomNo);

    /**
     * 채팅방 번호를 받아 시간에 따라 정렬된 첫 번재 채팅과 마지막 채팅 사이에 입장한 유저 이름들을 반환한다.
     * @param chatroomNo 채팅방 번호
     * @param firstChatTime 첫 번째 채팅
     * @param lastChatTime 마지막 채팅
     * @return 첫 번재 채팅과 마지막 채팅 사이에 입장한 유저들 이름
     */
    List<Chat> getAllEnterUserNamesByChatroomNoAndChatTime(@Param("chatroomNo") Long chatroomNo, @Param("firstChatTime") LocalDateTime firstChatTime, @Param("lastChatTime") LocalDateTime lastChatTime);

    /**
     * 채팅방 번호를 받아 시간에 따라 정렬된 첫 번재 채팅과 마지막 채팅 사이에 퇴장한 유저 이름을 받환한다.
     * @param chatroomNo 채팅방 번호
     * @param firstChatTime 첫 번째 채팅
     * @param lastChatTime 마지막 채팅
     * @return 첫 번재 채팅과 마지막 채팅 사이에 퇴장한 유저 이름
     */
    List<Chat> getAllOutUserNameByChatroomNoAndChatTime(@Param("chatroomNo") Long chatroomNo, @Param("firstChatTime") LocalDateTime firstChatTime, @Param("lastChatTime") LocalDateTime lastChatTime);

    /**
     * 채팅 번호로 채팅 객체를 가져온다.
     * @param chatNo 채팅 번호
     * @return 채팅 객체
     */
    Chat getChatByChatNo(@Param("chatNo") Long chatNo);

    /**
     * 이모지 번호로 이모지 객체를 가져온다.
     * @param emojiNo 이모지 번호
     * @return 이모지 객체
     */
    Emoji getEmojiByEmojiNo(@Param("emojiNo") Integer emojiNo);

    /**
     * 채팅창에 친 것을 중복 없이 담는다.
     * @param tagName 태그 이름
     * @return 이모지 번호가 담긴 set
     */
    Set<Integer> getEmojiNoByTagName(@Param("tagName") String tagName);
}
