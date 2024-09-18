package com.bbip.api.oauth.service;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

    private final DefaultOAuth2UserService defaultOAuth2UserService = new DefaultOAuth2UserService();

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        // DefaultOAuth2UserService를 이용해 OAuth2 사용자 정보를 가져옵니다.
        OAuth2User oAuth2User = defaultOAuth2UserService.loadUser(userRequest);

        // 여기서 사용자 정보를 처리합니다 (DB 저장 등)
        String name = oAuth2User.getAttribute("name");
        String email = oAuth2User.getAttribute("email");

        // 필요한 사용자 정보를 반환합니다.
        return new DefaultOAuth2User(
                Collections.singleton(new SimpleGrantedAuthority("ROLE_USER")),
                oAuth2User.getAttributes(),
                "name");  // 사용자 이름을 기본 값으로 설정
    }
}