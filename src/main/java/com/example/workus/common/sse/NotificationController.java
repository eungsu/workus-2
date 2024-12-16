package com.example.workus.common.sse;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {
    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @GetMapping("/register")
    public SseEmitter register() {
        SseEmitter emitter = new SseEmitter(60_000L);
//        SseEmitter emitter = new SseEmitter(120_000L);

        // 새로운 emitter를 서비스에 추가
        notificationService.addEmitter(emitter);

        // 클라이언트가 연결을 종료했을 때 처리
        emitter.onCompletion(() -> notificationService.removeEmitter(emitter));
        emitter.onTimeout(() -> notificationService.removeEmitter(emitter));

        // 에러 발생 시 처리
        emitter.onError((Throwable throwable) -> {
            notificationService.removeEmitter(emitter);
            // 로그 추가 또는 에러 처리 추가 가능
            System.err.println("Error occurred: " + throwable.getMessage());
        });

        // 클라이언트에 emitter 반환
        return emitter;
    }

    @PostMapping("/send")
    public void send(@RequestBody String message) {
        notificationService.sendMessageToAll(message);
    }
}
