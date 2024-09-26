package com.bbip.global.config;

import com.bbip.domain.rtmp.controller.SignalHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.*;

import java.util.Map;

@Configuration
@EnableWebSocketMessageBroker
@RequiredArgsConstructor
@EnableWebSocket
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer, WebSocketConfigurer  {

    // 커넥션에서 JWT인증을 하기 위한 인터셉터로, 아래 configureClientInboundChannel메서드에 호출됨
    // 일단 JWT인증 부분은 주석처리 하고 테스트 진행하는게 편할 듯
//    private final FilterChannelInterceptor filterChannelInterceptor;

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
//                .setAllowedOriginPatterns("*")
//                .addInterceptors(new CustomHandshakeInterceptor())  // 핸드셰이크 인터셉터 추가
                .withSockJS();
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(signalHandler(), "/signal")
                .setAllowedOrigins("http://localhost:3000")
                .withSockJS();
    }

    public WebSocketHandler signalHandler() {
        return new SignalHandler();
    }

//    @Override
//    public void configureMessageBroker(MessageBrokerRegistry registry) {
//        registry.enableSimpleBroker("/from");
//        registry.setApplicationDestinationPrefixes("/to");
//    }
//
//    @Override
//    public void configureClientInboundChannel(ChannelRegistration registration) {
//        registration.interceptors(filterChannelInterceptor);
//    }

}
