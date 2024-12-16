package com.example.workus.chat.service;

import com.example.workus.chat.dto.AddNewUserInChatroomForm;
import com.example.workus.chat.dto.ChatroomDto;
import com.example.workus.chat.dto.ChatroomInfoDto;
import com.example.workus.chat.dto.ChatroomForm;
import com.example.workus.chat.mapper.ChatroomMapper;
import com.example.workus.chat.vo.Chatroom;
import com.example.workus.user.dto.DeptDto;
import com.example.workus.user.dto.ParticipantInChatroomDto;
import com.example.workus.user.mapper.UserMapper;
import com.example.workus.user.vo.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@Transactional
@Service
public class ChatroomServcie {

    private final ChatroomMapper chatroomMapper;
    private final UserMapper userMapper;

    @Autowired
    public ChatroomServcie(ChatroomMapper chatroomMapper, UserMapper userMapper) {
        this.chatroomMapper = chatroomMapper;
        this.userMapper = userMapper;
    }

    /**
     * @return 로그인한 유저no가 참여중인 채팅방들
     */
    public List<ChatroomDto> getAllChatrooms(Long userNo) {
        List<Long> chatroomNumbers = chatroomMapper.getChatroomNoByUserNo(userNo);
        List<ChatroomDto> chatrooms = new ArrayList<>();
        for (Long chatroomNo : chatroomNumbers) {
            ChatroomDto chatroomDto = chatroomMapper.getChatRoomInMenuByChatroomNo(chatroomNo);
            if (chatroomDto != null) {
                chatroomDto.setNotReadCount(chatroomMapper.getNotReadCount(userNo, chatroomNo));
            } else {
                chatroomDto = new ChatroomDto();
                Chatroom chatroom = chatroomMapper.getChatroomByChatroomNo(chatroomNo);
                chatroomDto.setChatroomNo(chatroomNo);
                chatroomDto.setChatroomTitle(chatroom.getTitle());
            }
            chatrooms.add(chatroomDto);
        }
        // 가장 최근 채팅이 위로 오도록 정렬
        Collections.sort(chatrooms, (chatroom1, chatroom2) -> {
            if (chatroom1.getLastChatDate() == null && chatroom2.getLastChatDate() == null) {
                return 0;
            }
            if (chatroom1.getLastChatDate() == null) {
                return 1;
            }
            if (chatroom2.getLastChatDate() == null) {
                return -1;
            }
            return chatroom2.getLastChatDate().compareTo(chatroom1.getLastChatDate());
        });
        return chatrooms;
    }

    public ChatroomInfoDto getChatroomInfo(Long chatroomNo) {
        return chatroomMapper.getChatroomInfoByChatroomNo(chatroomNo);
    }

    public void updateChatroomConTime(Long userNo, Long chatroomNo) {
        LocalDateTime now = LocalDateTime.now();
        chatroomMapper.updateChatroomConTime(userNo, chatroomNo, now);
    }

    public List<DeptDto> getAllDepts() {
        return userMapper.getAllDepts();
    }

    public Map<String, List<ParticipantInChatroomDto>> getAllUsersByDeptName(String deptName) {
        Map<String, List<ParticipantInChatroomDto>> map = new HashMap<>();
        List<ParticipantInChatroomDto> usersByDeptName = chatroomMapper.getAllUsersByDeptName(deptName);
        map.put(deptName, usersByDeptName);
        return map;
    }

    // 채팅방 생성
    public ChatroomDto addChatroom(Long userNo, ChatroomForm chatroomForm) {
        // 채팅방 생성
        Chatroom chatroom = new Chatroom();
        String chatroomTitle = chatroomForm.getChatroomTitle();
        chatroom.setUserNo(userNo);
        chatroom.setTitle(chatroomTitle);
        chatroomMapper.addChatroom(chatroom);

        // 채팅방 참여자들 번호 그릇 participantUserNumbers
        List<Long> participantUserNumbers = chatroomForm.getUserNo();

        // disabled로 해놔서 작성자는 들어오지 않아서 따로 추가
        participantUserNumbers.add(userNo);

        // 채팅방 참여 히스토리에 추가
        Long chatroomNo = chatroom.getNo(); // 한 번만 참조하기 위해서 선언
        for (Long participantUserNo : participantUserNumbers) {
            chatroomMapper.addChatroomHistory(chatroomNo, participantUserNo);
        }

        // ajax로 채팅방을 추가로 보여주기 위해 ChatroomDto에 담아서 반환
        ChatroomDto chatroomDto = new ChatroomDto();
        chatroomDto.setChatroomNo(chatroomNo);
        chatroomDto.setChatroomTitle(chatroomTitle);
        return chatroomDto;
    }

    public void outChatroomByChatroomNo(Long userNo, Long chatroomNo) {
        chatroomMapper.outChatroomByChatroomNo(userNo, chatroomNo);
    }

    public ChatroomInfoDto getChatroomInfoByChatroomNo(Long chatroomNo) {
        return chatroomMapper.getChatroomInfoByChatroomNo(chatroomNo);
    }

    public List<User> addNewUserByChatroomNo(AddNewUserInChatroomForm addNewUserInChatroomForm) {
        List<User> users = new ArrayList<>();
        for (User user : addNewUserInChatroomForm.getUsers()) {
            chatroomMapper.addChatroomHistory(addNewUserInChatroomForm.getChatroomNo(), user.getNo());
            users.add(userMapper.getUserByUserNo(user.getNo()));
        }
        return users;
    }
}
