package com.bbip.domain.rtmp.controller;

import com.bbip.domain.rtmp.Dto.WebSocketMessage;
import com.bbip.domain.rtmp.repository.SessionRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;
import java.io.IOException;
import java.util.*;

@Slf4j
@Component
public class SignalHandler extends TextWebSocketHandler {

    private final SessionRepository sessionRepositoryRepo = SessionRepository.getInstance();  // 세션 데이터 저장소
    private final ObjectMapper objectMapper = new ObjectMapper();
    private static final String MSG_TYPE_JOIN_ROOM = "join_room";
    private static final String MSG_TYPE_OFFER = "offer";
    private static final String MSG_TYPE_ANSWER = "answer";
    private static final String MSG_TYPE_CANDIDATE = "candidate";

    @Override
    public void afterConnectionEstablished(final WebSocketSession session) {
        // 웹소켓이 연결되면 실행되는 메소드
    }

    @Override
    protected void handleTextMessage(final WebSocketSession session, final TextMessage textMessage) {


    }

    @Override
    public void afterConnectionClosed(final WebSocketSession session, final CloseStatus status) {


    }

    // 메세지 발송
    private void sendMessage(WebSocketSession session, WebSocketMessage message) {

    }
}
