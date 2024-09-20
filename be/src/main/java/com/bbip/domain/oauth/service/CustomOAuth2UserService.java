package com.bbip.domain.oauth.service;

import com.bbip.domain.token.service.TokenService;
import com.bbip.domain.user.entity.User;
import com.bbip.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Map;


@Service
@RequiredArgsConstructor
@Slf4j
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final TokenService tokenService;
    private final UserService userService;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {

        OAuth2User oAuth2User = super.loadUser(userRequest);
        log.info("oAuth2User: {}", oAuth2User);

        Map<String, Object> attributes = oAuth2User.getAttributes();

        String email = (String) attributes.get("email");
        log.info("email: {}", email);
        String name = (String) attributes.get("name");
        log.info("name: {}", name);
        String oauthProvider = "google";

        User user = userService.saveOrUpdateOAuthUser(email, name, oauthProvider);
        log.info("user: {}", user);

        // JWT 및 Refresh Token 발급
        String accessToken = tokenService.generateAccessToken(email);
        String refreshToken = tokenService.generateRefreshToken(email);

        // Redis에 Refresh Token 저장 (storeRefreshToken 호출)
        tokenService.generateRefreshToken(email);

        // 여기서 토큰을 클라이언트로 전달 (예시: 로그로 출력하거나 응답으로 반환)
        log.info("accessToken: {}", accessToken);
        log.info("refreshToken: {}", refreshToken);

        return oAuth2User;
    }
}