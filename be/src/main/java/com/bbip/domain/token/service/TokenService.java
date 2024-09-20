package com.bbip.domain.token.service;

import com.bbip.config.JwtTokenProvider;
import com.bbip.config.RedisTokenStore;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TokenService {

    private final JwtTokenProvider jwtTokenProvider;
    private final RedisTokenStore redisTokenStore;

    // Access Token 및 Refresh Token 발급
    public String generateAccessToken(String username) {
        return jwtTokenProvider.generateToken(username);
    }

    public String generateRefreshToken(String username) {
        String refreshToken = jwtTokenProvider.generateRefreshToken(username);
        long refreshTokenExpirationTime = jwtTokenProvider.getRefreshTokenExpirationTime();

        // Redis에 Refresh Token 저장
        redisTokenStore.storeRefreshToken(username, refreshToken, refreshTokenExpirationTime);
        return refreshToken;
    }

    // Redis에서 Refresh Token 검증
    public boolean validateRefreshToken(String username, String refreshToken) {
        String storedToken = redisTokenStore.getRefreshToken(username);
        return storedToken != null && storedToken.equals(refreshToken);
    }

    // 로그아웃 시 Refresh Token 삭제
    public void removeRefreshToken(String username) {
        redisTokenStore.removeRefreshToken(username);
    }
}