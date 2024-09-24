package com.bbip.global.interceptor;

import com.bbip.global.exception.InvalidTokenException;
import com.bbip.global.exception.NoTokenException;
import com.bbip.global.util.JwtUtil;
import jakarta.annotation.Nullable;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import java.util.Objects;

@Slf4j
@Component
@RequiredArgsConstructor
@Order(Ordered.HIGHEST_PRECEDENCE + 99)
public class FilterChannelInterceptor implements ChannelInterceptor {

    private final JwtUtil jwtUtil;

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        log.info("필터체인인터셉터 먼저 들어왔어유");
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(message);

        if (Objects.equals(headerAccessor.getCommand(), StompCommand.CONNECT)
                || Objects.equals(headerAccessor.getCommand(), StompCommand.SEND)) {
            String token = removeBrackets(String.valueOf(headerAccessor.getNativeHeader("Authorization")));
            log.info("토큰이 들어왔나: "+ token);
            if (token.isBlank()) {
                throw new NoTokenException("헤더에 토큰이 없음");
            }
            token = jwtUtil.resolveToken(token);

            if (!jwtUtil.validateToken(token))
                throw new InvalidTokenException("유효하지 않은 토큰");
        }

        return message;
    }

    private String removeBrackets(String token) {
        if (token.startsWith("[") && token.endsWith("]")) {
            return token.substring(1, token.length() - 1);
        }
        return token;
    }
}
