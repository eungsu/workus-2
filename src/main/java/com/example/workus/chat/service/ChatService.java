package com.example.workus.chat.service;

import com.example.workus.chat.dto.ChatForm;
import com.example.workus.chat.mapper.ChatMapper;
import com.example.workus.chat.vo.Chat;
import com.example.workus.chat.vo.Emoji;
import com.example.workus.common.dto.DownloadFileData;
import com.example.workus.common.dto.ListDto;
import com.example.workus.common.s3.S3Service;
import com.example.workus.common.util.Pagination;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@Transactional
@Service
public class ChatService {
    private final ChatMapper chatMapper;
    private final S3Service s3Service;

    @Autowired
    public ChatService(ChatMapper chatMapper, S3Service s3Service) {
        this.chatMapper = chatMapper;
        this.s3Service = s3Service;
    }

    private static final String CHAT_DIR = "/chat";

    @Value("${cloud.aws.s3.bucket}")
    private String bucketName;

    @Value("${cloud.aws.s3.folder}")
    private String folder;

    private static final String[] imageExtensions = {"jpg", "jpeg", "png", "gif", "bmp", "webp", "svg"};

    public ListDto<Chat> getAllChatsByChatroomNo(Long userNo, Long chatroomNo, int page) {
        int totalRows = chatMapper.getTotalRows(userNo, chatroomNo);
        Pagination pagination = new Pagination(page, totalRows);
        ListDto<Chat> dto;
        // 채팅방이 생성되고 친 채팅이 존재할 때
        if(pagination.getBegin() != 0) {
            // 가장 첫 페이지일 때 -> 더보기 때 10개씩 하기 위해 첫 페이지인 경우는 11개를 보여준다.
            dto = new ListDto<>(chatMapper.getAllChatsByChatroomNo(userNo, chatroomNo, pagination.getBegin() - 1), pagination);
            // 확장자에 따라 file이나 image로 type을 설정한다.
            for (Chat chat : dto.getData()) {
                if (chat.getFileSrc() != null) {
                    chat.setType("file");
                    String extension = chat.getFileSrc().toLowerCase();
                    for (String imageExtension : imageExtensions) {
                        if (extension.endsWith("." + imageExtension)) {
                            chat.setType("image");
                            break;
                        }
                    }
                } else if (chat.getEmoji() != null) {
                    chat.setType("emoji");
                }
            }
            Collections.sort(dto.getData(), (data1, data2) ->
                    data1.getTime().compareTo(data2.getTime()));
            LocalDateTime firstChatTime = dto.getData().getFirst().getTime();
            LocalDateTime lastChatTime = dto.getData().getLast().getTime();

            // 입장하는 유저들 리스트와 입장 시간을 리스트로 받는다.
            // begin이 0이면 현재 시간부터 <- 1부터 하니깐 첫 채팅을 치지 않으면 입장 퇴장 표시가 나타나지 않음
            // lastChatTime이 10개 중 가장 아래 있는 채팅 시간(최근 채팅)
            List<Chat> enterMessages = null;
            if (pagination.getBegin() == 1) {
                enterMessages = chatMapper.getAllEnterUserNamesByChatroomNoAndChatTime(chatroomNo, firstChatTime, LocalDateTime.now());
            } else {
                enterMessages = chatMapper.getAllEnterUserNamesByChatroomNoAndChatTime(chatroomNo, firstChatTime, lastChatTime);
            }
            List<String> enterUserNames = new ArrayList<>();
            while (enterMessages != null && !enterMessages.isEmpty()) {
                Chat prev = enterMessages.removeFirst();
                LocalDateTime prevTime = prev.getTime();
                // 채팅방에 한 번에 들어온 사람들을 리스트로 묶는다.
                if (!enterMessages.isEmpty() && prevTime.equals((enterMessages.getFirst().getTime()))) {
                    enterUserNames.add(prev.getUser().getName());
                    continue;
                }
                enterUserNames.add(prev.getUser().getName());
                prev.setContent(getEnterTextMessage(enterUserNames));
                enterUserNames.clear();
                prev.setType("message");
                dto.getData().add(prev);
            }

            // 퇴장하는 유저들 리스트와 퇴장 시간을 리스트로 받는다.
            List<Chat> outMessages = null;
            if (pagination.getBegin() == 1) {
                outMessages = chatMapper.getAllOutUserNameByChatroomNoAndChatTime(chatroomNo,firstChatTime, LocalDateTime.now());
            } else {
                outMessages = chatMapper.getAllOutUserNameByChatroomNoAndChatTime(chatroomNo,firstChatTime, lastChatTime);
            }
            while (enterMessages != null && !outMessages.isEmpty()) {
                Chat outMessage = outMessages.removeFirst();
                outMessage.setType("message");
                outMessage.setContent(outMessage.getUser().getName() + "님이 퇴장하셨습니다.");
                dto.getData().add(outMessage);
            }
            // 입장 퇴장 메시지를 넣고 다시 정렬
            Collections.sort(dto.getData(), (data1, data2) ->
                    data1.getTime().compareTo(data2.getTime()));
            // 채팅방이 생성되고 친 채팅이 없을 때
        } else {
            dto = new ListDto<>(Collections.emptyList(), pagination);
        }
        return dto;
    }

    public Chat insertChat(Chat chat) {
        chat.setTime(LocalDateTime.now());
        if (chatMapper.checkDailyFirstChat(chat).equals('N')) {
            chat.setIsFirst('Y');
        }
        chatMapper.insertChat(chat);
        return chat;
    }

    /**
     * 입장 표시를 위한 메시지들을 담아서 입장 표시 메시지를 반환
     * @param enterUserNames 한 번에 표시 할 (같은 시간에) 입장한 유저들
     * @return 입장 메시지
     */
    public String getEnterTextMessage(List<String> enterUserNames) {
        StringBuilder sb = new StringBuilder();
        int len = enterUserNames.size();
        // 입장한 사람이 두 명이상인 경우만 ", "추가
        // 한 명이거나 마지막 사람은 ,없애고 입장하셨습니다.
        if (len > 1) {
            for (int i = 0; i < len - 1; i++) {
                sb.append(enterUserNames.get(i) + ", ");
            }
        }
        sb.append(enterUserNames.getLast() + "님이 입장하셨습니다.");
        return sb.toString();
    }

    public Chat uploadFile(ChatForm chatForm) {
        MultipartFile file = chatForm.getUpfile();
        String originalFilename = file.getOriginalFilename();
        String filename = System.currentTimeMillis() + originalFilename;
        s3Service.uploadFile(file, bucketName, folder + CHAT_DIR, filename);
        Chat chat = new Chat();
        chat.setFileSrc(filename);
        return chat;
    }

    public DownloadFileData downloadFile(Long chatNo) {
        Chat chat = chatMapper.getChatByChatNo(chatNo);
        ByteArrayResource resource = s3Service.downloadFile(bucketName, folder + CHAT_DIR, chat.getFileSrc());
        return new DownloadFileData(chat.getFileSrc(), resource);
    }

    /**
     * 태그 번호를 중복이 존재하면 안되니 set에 담은 후 set에 담긴 no로 이모지 객체를 list에 담는다.
     * @param tagName 태그 이름
     * @return 이모지 객체 리스트
     */
    public List<Emoji> getEmojiByTagName(String tagName) {
        List<Emoji> emojiList = new ArrayList<>();
        Set<Integer> emojiTagNumbers = chatMapper.getEmojiNoByTagName(tagName);
        Iterator<Integer> iterator = emojiTagNumbers.iterator();
        while (iterator.hasNext()) {
            emojiList.add(chatMapper.getEmojiByEmojiNo(iterator.next()));
            iterator.remove();
        }
        return emojiList;
    }
}
