package com.bbip.global.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeFailureException;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.util.Map;

@Slf4j
@Component
public class CustomHandshakeInterceptor implements HandshakeInterceptor {

    @Override
    public boolean beforeHandshake(ServerHttpRequest request,
                                   ServerHttpResponse response,
                                   WebSocketHandler wsHandler,
                                   Map<String, Object> attributes) throws Exception {
        log.info("WebSocket Handshake 시작 - URI: {}", request.getURI());
        if (request instanceof ServletServerHttpRequest) {
            String token = request.getHeaders().getFirst("Authorization");

            log.info("token: {}", token);
            if (token != null) {
                attributes.put("Authorization", token);
            }
        }
//        String accessToken = request.getHeaders().getFirst("Authorization");
//        if (accessToken != null) {
//            attributes.put("Authorization", accessToken);  // 세션에 토큰 저장
//        }
        return true;
    }

    @Override
    public void afterHandshake(ServerHttpRequest request,
                               ServerHttpResponse response,
                               WebSocketHandler wsHandler,
                               Exception exception) {
        if (exception != null) {
            log.error("WebSocket Handshake 실패", exception);
        } else {
            log.info("WebSocket Handshake 성공");
        }
    }
}
