package com.example.workus.chat.controller;

import com.example.workus.chat.dto.ChatroomDto;
import com.example.workus.chat.service.ChatroomServcie;
import com.example.workus.security.LoginUser;
import com.example.workus.user.dto.DeptDto;
import com.example.workus.user.dto.ParticipantInChatroomDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/chatroom")
public class ChatroomController {

    private final ChatroomServcie chatroomServcie;

    @Autowired
    public ChatroomController(ChatroomServcie chatroomServcie) {
        this.chatroomServcie = chatroomServcie;
    }

    // 왼쪽 메뉴에 필요한 것들을 가져온다.
    @GetMapping("/list")
    public String getAllChatrooms(@AuthenticationPrincipal LoginUser loginUser, Model model) {
        // 1. 채팅방들을 가져온다.
        List<ChatroomDto> chatrooms = chatroomServcie.getAllChatrooms(loginUser.getNo());
        model.addAttribute("chatrooms", chatrooms);
        // 2-1. 채팅방 만들기에 필요한 부서 목록을 가져온다.
        List<DeptDto> depts = chatroomServcie.getAllDepts();
        model.addAttribute("depts", depts);
        // 2-2. 부서목록에 표시할 유저들을 담을 그릇을 정의한다.
        List<Map<String, List<ParticipantInChatroomDto>>> participantInfos = new ArrayList<>();
        // 2-3. 하나의 부서에 그에 해당하는 유저들을 넣는다.
        for (DeptDto dept : depts) {
            participantInfos.add(chatroomServcie.getAllUsersByDeptName(dept.getDeptName()));
        }
        model.addAttribute("participantInfos", participantInfos);
        return "chat/chatroom";
    }
}