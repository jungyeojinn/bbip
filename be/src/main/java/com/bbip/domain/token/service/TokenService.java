package com.bbip.domain.token.service;

public interface TokenService {
    String generateAccessToken(String username, Integer userId);
    String generateRefreshToken(String username);
    boolean validateRefreshToken(String username, String refreshToken);
    void removeRefreshToken(String username);
}
