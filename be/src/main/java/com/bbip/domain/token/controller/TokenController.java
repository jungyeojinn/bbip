package com.bbip.domain.token.controller;
import com.bbip.domain.token.service.TokenServiceImpl;
import io.swagger.v3.oas.annotations.Operation;
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

    private final TokenServiceImpl tokenService;

    /**
     * Refresh Token으로 새로운 Access Token 발급
     * @param request
     * @return
     */
    @Operation(
            summary = "엑세스 토큰 재발급",
            description = "userId, userName, refreshToken 입력 필요"
    )
    @PostMapping("/refresh-token")
    public ResponseEntity<?> refreshAccessToken(@RequestBody Map<String, String> request) {
        String userId = request.get("userId");
        String username = request.get("userName");
        String refreshToken = request.get("refreshToken");

        // Refresh Token 검증
        if (tokenService.validateRefreshToken(username, refreshToken)) {
            String newAccessToken = tokenService.generateAccessToken(username, Integer.parseInt(userId));
            return ResponseEntity.ok(Map.of("accessToken", newAccessToken));
        } else {
            return ResponseEntity.status(401).body("Invalid refresh token");
        }
    }

    /**
     * 로그아웃 시 Refresh Token 삭제
     * @param request
     * @return
     */
    @Operation(
            summary = "로그아웃",
            description = "로그아웃 시 Refresh Token 삭제하기 위한 api"
    )
    @PostMapping("/logout")
    public ResponseEntity<?> logout(@RequestBody Map<String, String> request) {
        String email = request.get("email");

        // Redis에서 Refresh Token 삭제
        tokenService.removeRefreshToken(email);
        return ResponseEntity.ok("Logged out successfully");
    }
}