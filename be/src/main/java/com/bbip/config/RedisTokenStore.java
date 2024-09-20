package com.bbip.config;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

@Component
@RequiredArgsConstructor
public class RedisTokenStore {

    @Autowired
    private final StringRedisTemplate redisTemplate;

    // Refresh Token 저장
    public void storeRefreshToken(String username, String refreshToken, long expirationTime) {
        redisTemplate.opsForValue().set(username, refreshToken, expirationTime, TimeUnit.MILLISECONDS);
    }

    // Refresh Token 조회
    public String getRefreshToken(String username) {
        return redisTemplate.opsForValue().get(username);
    }

    // Refresh Token 삭제 (로그아웃 시)
    public void removeRefreshToken(String username) {
        redisTemplate.delete(username);
    }
}