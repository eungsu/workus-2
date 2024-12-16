package com.example.workus.user.controller;

import jakarta.annotation.PostConstruct;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.Random;

@RestController
@RequestMapping("/ajax")
public class RestMessageController {
    private final DataSourceTransactionManagerAutoConfiguration dataSourceTransactionManagerAutoConfiguration;
    // coolSMS에서 제공하는 Service를 이용한다.
    private DefaultMessageService messageService;

    @Value("${coolsms.api.key}")
    private String apiKey;

    @Value("${coolsms.api.secret}")
    private String apiSecret;

    @Value("${coolsms.api.phone}")
    private String senderPhoneNumber;

    public RestMessageController(DataSourceTransactionManagerAutoConfiguration dataSourceTransactionManagerAutoConfiguration) {
        this.dataSourceTransactionManagerAutoConfiguration = dataSourceTransactionManagerAutoConfiguration;
    }

    @PostConstruct
    public void init() {
        try {
            this.messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecret, "https://api.coolsms.co.kr");
        } catch (RuntimeException e) {
            throw new RuntimeException(e);
        }
    }

    @GetMapping("/send-sms")
    public ResponseEntity<Map<String, Object>> sendSms(@RequestParam("phoneNumber") String phoneNumber) {

        Message message = new Message();
        Random r = new Random();
        int checkNum = r.nextInt(888888) + 111111; // 6자리의 난수 생성

        message.setFrom(senderPhoneNumber);
        message.setTo(phoneNumber); // 전달받은 휴대폰 번호를 바탕으로 문자를 발신한다.
        message.setText("[Workus] 휴대폰 인증코드는 " + checkNum + "입니다.");

        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));

        if("2000".equals(response.getStatusCode())) {
            return ResponseEntity.ok(Map.of("success", true, "checkNum", checkNum));
        } else {
            return ResponseEntity.ok(Map.of("success", false, "error", response.getStatusCode()));
        }
    }
}