package com.example.workus.common.sse;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class NotificationService {
    private final List<SseEmitter> emitters = new CopyOnWriteArrayList<>();

    /**
     * 클라이언트의 연결을 관리하기 위해 새 emitter를 emitters 리스트에 추가합니다.
     *
     * @param emitter 등록할 SseEmitter 인스턴스
     */
    public void addEmitter(SseEmitter emitter) {
        // emitter를 리스트에 추가
        emitters.add(emitter);

        // 더미 데이터 전송하여 503 에러 방지
        try {
            emitter.send(SseEmitter.event()
                    .name("connect")
                    .data("connected!")); // 더미 데이터 전송
        } catch (Exception e) {
            // 오류가 발생한 emitter는 제거
            emitters.remove(emitter);
            // 로그 추가: 어떤 오류가 발생했는지 확인
            System.err.println("Emitter 오류: " + e.getMessage());
        }
    }

    /**
     * 모든 emitter에 메시지를 전송합니다.
     *
     * @param message 전송할 메시지
     */
    public void sendMessageToAll(String message) {
        for (SseEmitter emitter : emitters) {
            try {
                // 각 emitter에 메시지 전송
                emitter.send(message);
            } catch (Exception e) {
                // 오류가 발생한 emitter는 제거
                emitters.remove(emitter);
                // 로그 추가: 어떤 오류가 발생했는지 확인
                System.err.println("Emitter 오류: " + e.getMessage());
            }
        }
    }

    /**
     * 클라이언트와의 연결이 종료되었을 때 해당 emitter를 목록에서 안전하게 제거합니다.
     *
     * @param emitter 제거할 SseEmitter
     */
    public void removeEmitter(SseEmitter emitter) {
        emitters.remove(emitter);
    }
}