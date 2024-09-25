package com.bbip.global.config;

import com.bbip.domain.rtmp.controller.VideoStreamController;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;

@Component
@Slf4j
public class WebSocketEventListener {

    private final VideoStreamController videoStreamController;

    public WebSocketEventListener(VideoStreamController videoStreamController) {
        this.videoStreamController = videoStreamController;
    }

    @EventListener
    public void handleWebSocketConnectListener(SessionConnectedEvent event) {

        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        log.info("Headers: " + headerAccessor.toNativeHeaderMap());
        String sessionId = headerAccessor.getSessionId();
        String accessToken = (String) event.getMessage().getHeaders().get("Authorization");
//        String accessToken = headerAccessor.getFirstNativeHeader("Authorization");

        log.info(sessionId + ":" + accessToken);
        if (accessToken != null) {
            videoStreamController.initializeFfmpegProcess(sessionId, accessToken);
        }
    }
}
