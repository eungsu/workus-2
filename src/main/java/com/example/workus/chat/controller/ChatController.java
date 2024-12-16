package com.example.workus.chat.controller;

import com.example.workus.chat.service.ChatService;
import com.example.workus.common.dto.DownloadFileData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

@Controller
@RequestMapping("/chat")
public class ChatController {

    private final ChatService chatService;

    @Autowired
    public ChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    @GetMapping("/download/{chatNo}")
    public ResponseEntity<ByteArrayResource> downloadFile(@PathVariable("chatNo") Long chatNo) {
        DownloadFileData downloadFileData = chatService.downloadFile(chatNo);

        try {
            String filename = downloadFileData.getFilename();
            String encodedFilename = URLEncoder.encode(filename.substring(13), "UTF-8");

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFilename + "\"")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .contentLength(downloadFileData.getResource().contentLength())
                    .body(downloadFileData.getResource());
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("파일 이름 인코딩 실패", e);
        }
    }
}
