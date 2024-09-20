package com.bbip.domain.token.service;

import com.bbip.global.util.JwtUtil;
import com.bbip.global.util.RedisUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TokenServiceImpl implements TokenService {

    private final JwtUtil jwtUtil;
    private final RedisUtil redisUtil;

    /**
     * Access Token 발급
     * @param username
     * @param userId
     * @return
     */
    @Override
    public String generateAccessToken(String username, Integer userId) {
        return jwtUtil.generateToken(username, userId);
    }

    /**
     * Refresh Token 발급
     * @param username
     * @return
     */
    @Override
    public String generateRefreshToken(String username) {
        String refreshToken = jwtUtil.generateRefreshToken(username);
        long refreshTokenExpirationTime = jwtUtil.getRefreshTokenExpirationTime();

        // Redis에 Refresh Token 저장
        redisUtil.setDataExpire(username, refreshToken, refreshTokenExpirationTime);
        return refreshToken;
    }

    /**
     * Redis에서 Refresh Token 검증
     * @param username
     * @param refreshToken
     * @return
     */
    @Override
    public boolean validateRefreshToken(String username, String refreshToken) {
        String storedToken = redisUtil.getData(username);
        return storedToken != null && storedToken.equals(refreshToken);
    }

    /**
     * 로그아웃 시 Refresh Token 삭제
     * @param username
     */
    @Override
    public void removeRefreshToken(String username) {
        redisUtil.removeData(username);
    }
}