package com.example.workus.common.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    private final ChatSocketHandler chatSocketHandler;

    @Autowired
    public WebSocketConfig(ChatSocketHandler chatSocketHandler) {
        this.chatSocketHandler = chatSocketHandler;
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(chatSocketHandler, "/socket/chat").withSockJS().setInterceptors(new HttpSessionHandshakeInterceptor());
    }
}
