package com.example.workus.chat.controller;

import com.example.workus.chat.dto.ChatForm;
import com.example.workus.chat.vo.Emoji;
import com.example.workus.common.dto.ListDto;
import com.example.workus.common.dto.RestResponseDto;
import com.example.workus.chat.service.ChatService;
import com.example.workus.chat.vo.Chat;
import com.example.workus.security.LoginUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/ajax")
public class RestChatController {

    private final ChatService chatService;

    @Autowired
    public RestChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    @GetMapping("/chat/{page}/{chatroomNo}")
    ResponseEntity<RestResponseDto<ListDto<Chat>>> getAllChats(
            @AuthenticationPrincipal LoginUser loginUser,
            @PathVariable("chatroomNo") Long chatroomNo,
            @PathVariable("page") int page) {
        return ResponseEntity.ok(RestResponseDto.success(chatService.getAllChatsByChatroomNo(loginUser.getNo(), chatroomNo, page)));
    }

    @PostMapping("/chat/upload")
    ResponseEntity<RestResponseDto<Chat>> uploadFile(@ModelAttribute ChatForm chatForm) {
        return ResponseEntity.ok(RestResponseDto.success(chatService.uploadFile(chatForm)));
    }

    @GetMapping("/chat/emoji/{tagName}")
    ResponseEntity<RestResponseDto<List<Emoji>>> getChatByTagName(@PathVariable("tagName") String tagName) {
        return ResponseEntity.ok(RestResponseDto.success(chatService.getEmojiByTagName(tagName)));
    }
}
