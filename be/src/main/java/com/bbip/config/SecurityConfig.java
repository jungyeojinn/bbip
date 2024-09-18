package com.bbip.config;

import com.bbip.api.oauth.service.CustomOAuth2UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final CustomOAuth2UserService customOAuth2UserService;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf().disable()
                .authorizeHttpRequests()
                .requestMatchers("/").permitAll()
                .requestMatchers("/login").permitAll()
                .requestMatchers("/oauth2/**").permitAll()
                .anyRequest().authenticated()
                .and()
                .oauth2Login()  // Spring Security 기본 로그인 페이지 사용
                .defaultSuccessUrl("/home", true)
                .userInfoEndpoint()
                .userService(customOAuth2UserService);  // OAuth2 사용자 정보 처리

        return http.build();
    }
}
