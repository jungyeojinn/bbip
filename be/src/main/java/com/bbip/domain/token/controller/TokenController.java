package com.bbip.domain.token.controller;
import com.bbip.domain.token.service.TokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class TokenController {

    private final TokenService tokenService;

    // Refresh Token으로 새로운 Access Token 발급
    @PostMapping("/refresh-token")
    public ResponseEntity<?> refreshAccessToken(@RequestBody Map<String, String> request) {
        String username = request.get("username");
        String refreshToken = request.get("refreshToken");

        // Refresh Token 검증
        if (tokenService.validateRefreshToken(username, refreshToken)) {
            String newAccessToken = tokenService.generateAccessToken(username);
            return ResponseEntity.ok(Map.of("accessToken", newAccessToken));
        } else {
            return ResponseEntity.status(401).body("Invalid refresh token");
        }
    }

    // 로그아웃 시 Refresh Token 삭제
    @PostMapping("/logout")
    public ResponseEntity<?> logout(@RequestBody Map<String, String> request) {
        String email = request.get("email");

        // Redis에서 Refresh Token 삭제
        tokenService.removeRefreshToken(email);
        return ResponseEntity.ok("Logged out successfully");
    }
}